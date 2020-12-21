//
//  FavoritesService.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-12-20.
//

import Foundation
import Combine

protocol FavoritesService {
  var favoritesPublisher: AnyPublisher<[Restaurant], Never> { get }
  func add(favorite: Restaurant)
  func remove(favoriteID: String)
}

final class FavoritesServiceAdapter: FavoritesService {
  static let shared = FavoritesServiceAdapter()
  
  private var favorites: [Restaurant] = [] {
    didSet {
      currentValue.value = favorites
    }
  }
  private var currentValue = CurrentValueSubject<[Restaurant], Never>([])
  var favoritesPublisher: AnyPublisher<[Restaurant], Never> {
    return currentValue.eraseToAnyPublisher()
  }
  private var favoritesURL: URL {
    let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    return URL(fileURLWithPath: "favorites", relativeTo: directory)
  }
  
  private init() {
    retrieveFavorites()
  }
  
  func add(favorite: Restaurant) {
    guard favorites.first(where: { $0.restaurantID == favorite.restaurantID }) == nil else { return }
    favorites.append(favorite)
    saveFavorites()
  }
  
  func remove(favoriteID: String) {
    guard let index = favorites.firstIndex(where: { $0.restaurantID == favoriteID }) else { return }
    favorites.remove(at: index)
    saveFavorites()
  }
}

private extension FavoritesServiceAdapter {
  func retrieveFavorites() {
    guard
      let data = try? Data(contentsOf: favoritesURL),
      let favorites = try? JSONDecoder().decode([Restaurant].self, from: data)
    else { return }
    self.favorites = favorites
  }
  
  func saveFavorites() {
    do {
      let data = try JSONEncoder().encode(favorites)
      try data.write(to: favoritesURL)
    } catch {
      print("Error saving favorites: \(error)")
    }
  }
}
