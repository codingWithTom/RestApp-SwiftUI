//
//  RemoveFavorite.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-12-20.
//

import Foundation

protocol RemoveFavorite {
  func execute(favoriteID: String)
}

final class RemoveFavoriteAdapter: RemoveFavorite {
  struct Dependencies {
    var favoritesService: FavoritesService = FavoritesServiceAdapter.shared
  }
  private let dependencies: Dependencies
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
  }
  
  func execute(favoriteID: String) {
    dependencies.favoritesService.remove(favoriteID: favoriteID)
  }
}
