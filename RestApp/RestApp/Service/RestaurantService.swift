//
//  RestaurantService.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-10-06.
//

import Foundation

protocol RestaurantService {
  func getCategories(completion: @escaping ([RestaurantCategory]) -> Void)
}

final class RestaurantServiceAdapter: RestaurantService {
  static let shared = RestaurantServiceAdapter()
  private init() {}
  
  func getCategories(completion: @escaping ([RestaurantCategory]) -> Void) {
    guard let url = URL(string: "http://localhost:3000/restaurants") else { return }
    let dataTask = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
      guard
        let jsonData = data,
        let categories = try? JSONDecoder().decode([RestaurantCategory].self, from: jsonData)
      else {
        completion([])
        return
      }
      completion(categories)
    }
    dataTask.resume()
  }
}
