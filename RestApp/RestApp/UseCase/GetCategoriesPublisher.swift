//
//  GetCategoriesPublisher.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-11-28.
//

import Foundation
import Combine

protocol GetCategoriesPublisher {
  func execute() -> AnyPublisher<[RestaurantCategory], Never>
}

final class GetCategoriesPublisherAdapter: GetCategoriesPublisher {
  struct Dependencies {
    var restaurantService: RestaurantService = RestaurantServiceAdapter.shared
  }
  private let dependencies: Dependencies
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
  }
  
  func execute() -> AnyPublisher<[RestaurantCategory], Never> {
    return dependencies.restaurantService.categoriesPublisher
  }
}
