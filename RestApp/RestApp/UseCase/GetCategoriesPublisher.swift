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
  func updateSearchFor(text: String, dishType: DishType)
}

final class GetCategoriesPublisherAdapter: GetCategoriesPublisher {
  struct Dependencies {
    var restaurantService: RestaurantService = RestaurantServiceAdapter.shared
  }
  private let dependencies: Dependencies
  private var currentValueSubject = CurrentValueSubject<[RestaurantCategory], Never>([])
  private var categories: [RestaurantCategory] = []
  private var cancellable: AnyCancellable?
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
    cancellable = dependencies.restaurantService.categoriesPublisher.sink { [weak self] in
      self?.categories = $0
      self?.currentValueSubject.value = $0
    }
  }
  
  func execute() -> AnyPublisher<[RestaurantCategory], Never> {
    return currentValueSubject.eraseToAnyPublisher()
  }
  
  func updateSearchFor(text: String, dishType: DishType) {
    guard !text.isEmpty else {
      currentValueSubject.value = categories
      return
    }
    currentValueSubject.value = categoriesFor(text: text, dishType: dishType)
  }
}

private extension GetCategoriesPublisherAdapter {
  func categoriesFor(text: String, dishType: DishType) -> [RestaurantCategory] {
    var restaurants = categories.flatMap { category in category.restaurants }
    restaurants = restaurants.filter { $0.name.contains(text) }
    if dishType != .none {
      restaurants = restaurants.filter { $0.dishTypes.contains(dishType) }
    }
    return [RestaurantCategory(categoryID: "Filtered", name: "Filtered", iconImageName: "magnifyingglass", restaurants: restaurants)]
  }
}
