//
//  TabbarViewModel.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-12-21.
//

import Foundation
import Combine

final class TabBarViewModel: ObservableObject {
  struct Dependencies {
    var favoritesPublisher: GetFavoritesPublisher = GetFavoritesPublisherAdapter()
    var notificationsPublisher: GetRestaurantNotificationsPublisher = GetRestaurantNotificationsPublisherAdapter()
    var getRestaurant: GetRestaurant = GetRestaurantAdapter()
  }
  private let dependencies: Dependencies
  @Published var numberOfFavorites: Int = 0
  @Published var presentedRestaurant: Restaurant?
  private var favoritesSubscriber: AnyCancellable?
  private var notificationsSubscriver: AnyCancellable?
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
    observe()
  }
}

private extension TabBarViewModel {
  func observe() {
    favoritesSubscriber = dependencies.favoritesPublisher.execute().receive(on: RunLoop.main).sink { [weak self] in
      self?.numberOfFavorites = $0.count
    }
    notificationsSubscriver = dependencies.notificationsPublisher.execute().receive(on: RunLoop.main).sink { [weak self] in
      guard let restaurant = self?.dependencies.getRestaurant.execute(for: $0) else { return }
      self?.presentedRestaurant = restaurant
    }
  }
}
