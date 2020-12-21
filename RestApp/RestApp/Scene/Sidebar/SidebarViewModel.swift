//
//  SidebarViewModel.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-12-21.
//

import Foundation
import Combine
import SwiftUI

final class SidebarViewModel: ObservableObject {
  struct Dependencies {
    var favoritesPublisher: GetFavoritesPublisher = GetFavoritesPublisherAdapter()
    var addFavorite: AddFavorite = AddFavoriteAdapter()
    var removeFavorite: RemoveFavorite = RemoveFavoriteAdapter()
  }
  private let dependencies: Dependencies
  private var favoritesSubscriber: AnyCancellable?
  @Published var favorites: [Restaurant] = []
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
    observe()
  }
  
  func addFavoriteFromItems(_ items: [NSItemProvider]) {
    items.forEach { item in
      item.loadObject(ofClass: RestaurantDropItem.self) { [weak self] dropItem, error in
        guard error == nil, let restaurantDropItem = dropItem as? RestaurantDropItem else { return }
        self?.dependencies.addFavorite.execute(favorite: restaurantDropItem.restaurant)
      }
    }
  }
  
  func removeFrom(indexSet: IndexSet) {
    indexSet.forEach {
      let favorite = favorites[$0]
      dependencies.removeFavorite.execute(favoriteID: favorite.restaurantID)
    }
  }
}

private extension SidebarViewModel {
  func observe() {
    favoritesSubscriber = dependencies.favoritesPublisher.execute().receive(on: RunLoop.main).sink { [weak self] in
      self?.favorites = $0
    }
  }
}

