//
//  RateViewModel.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-10-26.
//

import Foundation

final class RateViewModel {
  struct Dependencies {
    var rateRestaurant: RateRestaurant = RateRestaurantAdapter()
  }
  private let dependencies: Dependencies
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
  }
  
  func rate(restaurantID: String, score: Int, comment: String) {
    dependencies.rateRestaurant.execute(restaurantID: restaurantID, comment: comment, score: score)
  }
}
