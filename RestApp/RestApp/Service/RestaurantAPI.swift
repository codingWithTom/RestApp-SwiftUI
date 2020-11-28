//
//  RestaurantAPI.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-11-28.
//

import Foundation

protocol RestaurantAPI {
  func getCategories(completion: @escaping ([RestaurantCategory]) -> Void)
  func rateRestaurant(restaurantID: String, categoryID: String, score: Int, comment: String, completion: @escaping ([RestaurantCategory]) -> Void)
}

final class RestaurantAPIAdapter:RestaurantAPI {
  private let domain = "localhost:3000"
  
  func getCategories(completion: @escaping ([RestaurantCategory]) -> Void) {
    guard let url = URL(string: "http://\(domain)/restaurants") else { return }
    let dataTask = URLSession.shared.dataTask(with: URLRequest(url: url)) { [weak self] data, response, error in
      self?.handleOutcome(data, completion: completion)
    }
    dataTask.resume()
  }
  
  func rateRestaurant(restaurantID: String, categoryID: String, score: Int, comment: String, completion: @escaping ([RestaurantCategory]) -> Void) {
    let body = ["score": "\(score)", "comment": comment]
    guard
      let url = URL(string: "http://\(domain)/restaurants/\(categoryID)/\(restaurantID)")
    else { return }
    var request = URLRequest(url: url)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try? JSONEncoder().encode(body)
    request.httpMethod = "POST"
    let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
      self?.handleOutcome(data, completion: completion)
    }
    task.resume()
  }
}

private extension RestaurantAPIAdapter {
  func handleOutcome(_ data: Data?, completion: @escaping ([RestaurantCategory]) -> Void) {
    guard
      let jsonData = data,
      let categories = try? JSONDecoder().decode([RestaurantCategory].self, from: jsonData)
    else {
      return
    }
    completion(categories)
  }
}
