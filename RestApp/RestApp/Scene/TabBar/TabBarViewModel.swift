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
  }
  private let dependencies: Dependencies
  @Published var numberOfFavorites: Int = 0
  private var favoritesSubscriber: AnyCancellable?
  
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
  }
}
