//
//  MockRestaurantService.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-10-26.
//

import Foundation
import Combine

final class MockRestaurantService: RestaurantService {
  static var mockCategories: [RestaurantCategory] {
    return [
      RestaurantCategory(categoryID: "1", name: "Lunch", iconImageName: "cross.fill", restaurants: [
        Restaurant(restaurantID: "1", name: "McD", description: "Some normal food", imageName: "restaurant1", ratings: [Rating(ratingID: "1", score: "3", comment: "Good food!")]),
        Restaurant(restaurantID: "2", name: "McE", description: "Some great food", imageName: "restaurant2", ratings: []),
        Restaurant(restaurantID: "3", name: "McC", description: "Some so so food", imageName: "restaurant3", ratings: []),
      ]),
      RestaurantCategory(categoryID: "2", name: "Dinning", iconImageName: "pencil.slash", restaurants: [
        Restaurant(restaurantID: "4", name: "McS", description: "Some normal food", imageName: "restaurant4", ratings: []),
        Restaurant(restaurantID: "5", name: "McT", description: "Some great food", imageName: "restaurant5", ratings: []),
        Restaurant(restaurantID: "6", name: "McR", description: "Some so so food", imageName: "restaurant3", ratings: []),
      ])
    ]
  }
  
  private var currentSubjectCategories = CurrentValueSubject<[RestaurantCategory], Never>([])
  let categories: [RestaurantCategory] = MockRestaurantService.mockCategories
  var categoriesPublisher: AnyPublisher<[RestaurantCategory], Never> {
    return currentSubjectCategories.eraseToAnyPublisher()
  }
  
  func getCategories() {
    currentSubjectCategories.value = categories
  }
  
  func rateRestaurant(restaurantID: String, score: Int, comment: String) { }
  
  func getRestaurant(for: String) -> Restaurant? {
    return nil
  }
}
