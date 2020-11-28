//
//  RestaurantCategory.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-10-06.
//

import Foundation

struct RestaurantCategory: Codable {
  let categoryID: String
  let name: String
  let iconImageName: String
  let restaurants: [Restaurant]
}
