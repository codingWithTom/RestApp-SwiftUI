//
//  GetRestaurant.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-11-28.
//

import Foundation

protocol GetRestaurant {
  func execute(for: String) -> Restaurant?
}

final class GetRestaurantAdapter: GetRestaurant {
  struct Dependencies {
    var restaurantService: RestaurantService = RestaurantServiceAdapter.shared
  }
  private let dependencies: Dependencies
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
  }
  
  func execute(for restaurantID: String) -> Restaurant? {
    return dependencies.restaurantService.getRestaurant(for: restaurantID)
  }
}
