//
//  RestaurantService.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-10-06.
//

import Foundation
import Combine

protocol RestaurantService {
  var categoriesPublisher: AnyPublisher<[RestaurantCategory], Never> { get }
  func getCategories()
  func rateRestaurant(restaurantID: String, score: Int, comment: String)
}

final class RestaurantServiceAdapter: RestaurantService {
  static let shared = RestaurantServiceAdapter()
  private init() {}
  private var categories: [RestaurantCategory] = [] {
    didSet {
      currentSubjectCategories.value = categories
    }
  }
  private var currentSubjectCategories = CurrentValueSubject<[RestaurantCategory], Never>([])
  
  var categoriesPublisher: AnyPublisher<[RestaurantCategory], Never> {
    return currentSubjectCategories.eraseToAnyPublisher()
  }
  
  func getCategories() {
    guard let url = URL(string: "http://localhost:3000/restaurants") else { return }
    let dataTask = URLSession.shared.dataTask(with: URLRequest(url: url)) { [weak self] data, response, error in
      self?.updateData(data)
    }
    dataTask.resume()
  }
  
  func rateRestaurant(restaurantID: String, score: Int, comment: String) {
    let category = categories.first { category in category.restaurants.contains { $0.restaurantID == restaurantID } }
    let body = ["score": "\(score)", "comment": comment]
    guard
      let categoryID = category?.categoryID,
      let url = URL(string: "http://localhost:3000/restaurants/\(categoryID)/\(restaurantID)")
    else { return }
    var request = URLRequest(url: url)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try? JSONEncoder().encode(body)
    request.httpMethod = "POST"
    let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
      self?.updateData(data)
    }
    task.resume()
  }
}

private extension RestaurantServiceAdapter {
  func updateData(_ data: Data?) {
    guard
      let jsonData = data,
      let categories = try? JSONDecoder().decode([RestaurantCategory].self, from: jsonData)
    else {
      return
    }
    self.categories = categories
  }
}
