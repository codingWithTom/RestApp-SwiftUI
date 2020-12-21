//
//  FavoritesViewModel.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-12-21.
//

import Foundation
import Combine

final class FavoritesViewModel: ObservableObject {
  struct Dependencies {
    var favoritesPublisher: GetFavoritesPublisher = GetFavoritesPublisherAdapter()
    var removeFavorite: RemoveFavorite = RemoveFavoriteAdapter()
  }
  private let dependencies: Dependencies
  private var favoritesSubscriber: AnyCancellable?
  @Published var favorites: [Restaurant] = []
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
    observe()
  }
  
  func removeFrom(indexSet: IndexSet) {
    indexSet.forEach {
      let favorite = favorites[$0]
      dependencies.removeFavorite.execute(favoriteID: favorite.restaurantID)
    }
  }
}

private extension FavoritesViewModel {
  func observe() {
    favoritesSubscriber = dependencies.favoritesPublisher.execute().receive(on: RunLoop.main).sink { [weak self] in
      self?.favorites = $0
    }
  }
}
