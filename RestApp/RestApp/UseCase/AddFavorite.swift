//
//  AddFavorite.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-12-20.
//

import Foundation

protocol AddFavorite {
  func execute(favorite: Restaurant)
}

final class AddFavoriteAdapter: AddFavorite {
  struct Dependencies {
    var favoritesService: FavoritesService = FavoritesServiceAdapter.shared
  }
  private let dependencies: Dependencies
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
  }
  
  func execute(favorite: Restaurant) {
    dependencies.favoritesService.add(favorite: favorite)
  }
}
