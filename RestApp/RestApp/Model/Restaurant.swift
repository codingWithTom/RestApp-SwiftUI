//
//  Restaurant.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-10-06.
//

import Foundation

enum DishType: String, Codable, CaseIterable {
  case none = "None"
  case vegetarian = "Vegetarian"
  case vegan = "Vegan"
  case glutenFree = "Gluten Free"
}

struct Restaurant: Codable {
  static let empty = Restaurant(restaurantID: "", name: "", description: "", imageName: "", ratings: [], images: [], dishTypes: [])
  
  let restaurantID: String
  let name: String
  let description: String
  let imageName: String
  let ratings: [Rating]
  let images: [String]
  let dishTypes: [DishType]
}
