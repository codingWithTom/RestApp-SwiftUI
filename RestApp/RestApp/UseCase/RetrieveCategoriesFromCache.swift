//
//  RetrieveCategoriesFromCache.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-11-28.
//

import Foundation

protocol RetrieveCategoriesFromCache {
  func execute()
}

final class RetrieveCategoriesFromCacheAdapter: RetrieveCategoriesFromCache {
  struct Dependencies {
    var restaurantService: RestaurantService = RestaurantServiceAdapter.shared
    var restaurantCache: RestaurantCache = RestaurantCacheAdapter.shared
  }
  private let dependencies: Dependencies
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
  }
  
  func execute() {
    let storedCategores = dependencies.restaurantCache.get()
    dependencies.restaurantService.update(with: storedCategores)
  }
}
