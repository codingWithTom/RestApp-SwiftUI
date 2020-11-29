//
//  RateRestaurant.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-11-28.
//

import Foundation

protocol RateRestaurant {
  func execute(restaurantID: String, comment: String, score: Int)
}

final class RateRestaurantAdapter: RateRestaurant {
  struct Dependencies {
    var restaurantService: RestaurantService = RestaurantServiceAdapter.shared
    var restaurantAPI: RestaurantAPI = RestaurantAPIAdapter()
    var restaurantCache: RestaurantCache = RestaurantCacheAdapter.shared
  }
  private let dependencies: Dependencies
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
  }
  
  func execute(restaurantID: String, comment: String, score: Int) {
    guard let category = dependencies.restaurantService.getCategory(forRestaurantID: restaurantID) else { return }
    dependencies.restaurantAPI.rateRestaurant(restaurantID: restaurantID, categoryID: category.categoryID,
                                              score: score, comment: comment) { [weak self] categories in
      self?.dependencies.restaurantService.update(with: categories)
      self?.dependencies.restaurantCache.set(categories)
    }
  }
}
