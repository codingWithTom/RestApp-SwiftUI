//
//  RestaurantService.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-10-06.
//

import Foundation
import Combine

protocol RestaurantService {
  var categoriesPublisher: AnyPublisher<[RestaurantCategory], Never> { get }
  func getRestaurant(for: String) -> Restaurant?
  func getCategory(forRestaurantID: String) -> RestaurantCategory?
  func update(with categories: [RestaurantCategory])
}

final class RestaurantServiceAdapter: RestaurantService {
  static let shared = RestaurantServiceAdapter()
  private init() {}
  private var categories: [RestaurantCategory] = [] {
    didSet {
      currentSubjectCategories.value = categories
    }
  }
  private var currentSubjectCategories = CurrentValueSubject<[RestaurantCategory], Never>([])
  
  var categoriesPublisher: AnyPublisher<[RestaurantCategory], Never> {
    return currentSubjectCategories.eraseToAnyPublisher()
  }
  
  func getRestaurant(for restaurantID: String) -> Restaurant? {
    for category in categories {
      if let restaurant = category.restaurants.first(where: { $0.restaurantID == restaurantID }) {
        return restaurant
      }
    }
    return nil
  }
  
  func getCategory(forRestaurantID restaurantID: String) -> RestaurantCategory? {
    let category = categories.first { cat in cat.restaurants.first { $0.restaurantID == restaurantID } != nil }
    return category
  }
  
  func update(with categories: [RestaurantCategory]) {
    self.categories = categories
  }
}
