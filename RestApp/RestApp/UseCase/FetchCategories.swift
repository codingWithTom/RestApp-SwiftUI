//
//  FetchCategories.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-11-28.
//

import Foundation

protocol FetchCategories {
  func execute()
}

final class FetchCategoriesAdapter: FetchCategories {
  struct Dependencies {
    var restaurantService: RestaurantService = RestaurantServiceAdapter.shared
    var restaurantAPI: RestaurantAPI = RestaurantAPIAdapter()
    var restaurantCache: RestaurantCache = RestaurantCacheAdapter.shared
  }
  private let dependencies: Dependencies
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
  }
  
  func execute() {
    dependencies.restaurantAPI.getCategories { [weak self] categories in
      self?.dependencies.restaurantService.update(with: categories)
      self?.dependencies.restaurantCache.set(categories)
    }
  }
}
