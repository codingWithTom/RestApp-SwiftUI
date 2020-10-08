//
//  Restaurant.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-10-06.
//

import Foundation

struct Restaurant: Decodable {
  let restaurantID: String
  let name: String
  let description: String
  let imageName: String
  let ratings: [Rating]
}
