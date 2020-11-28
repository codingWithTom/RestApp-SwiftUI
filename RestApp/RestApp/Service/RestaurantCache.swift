//
//  RestaurantCache.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-11-28.
//

import Foundation

protocol RestaurantCache {
  func get() -> [RestaurantCategory]
  func set(_: [RestaurantCategory])
}

final class RestaurantCacheAdapter: RestaurantCache {
  static let shared = RestaurantCacheAdapter()
  
  private var categoriesFilURL: URL {
    let userDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    return URL(fileURLWithPath: "categories", relativeTo: userDirectory)
  }
  
  private init() {}
  
  func get() -> [RestaurantCategory] {
    guard
      let data = try? Data(contentsOf: categoriesFilURL),
      let categories = try? JSONDecoder().decode([RestaurantCategory].self, from: data)
    else { return [] }
    
    return categories
  }
  
  func set(_ categories: [RestaurantCategory]) {
    do {
      let data = try? JSONEncoder().encode(categories)
      try data?.write(to: categoriesFilURL)
    } catch {
      print("Error storing data \(error)")
    }
  }
}
