//
//  RestaurantAppViewModel.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-11-28.
//

import Foundation

final class RestaurantAppViewModel {
  struct Dependencies {
    var retrieveCategories: RetrieveCategoriesFromCache = RetrieveCategoriesFromCacheAdapter()
  }
  private let dependencies: Dependencies
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
    dependencies.retrieveCategories.execute()
  }
}
