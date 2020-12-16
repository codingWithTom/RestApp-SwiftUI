//
//  RestaurantAppViewModel.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-11-28.
//

import Foundation

final class RestaurantAppViewModel: ObservableObject {
  private struct DeepLink {
    static let scheme = "cwt"
    static let restaurantDetailPath = "restaurant"
    static let restaurantIDQueryItem = "restaurantID"
  }
  struct Dependencies {
    var retrieveCategories: RetrieveCategoriesFromCache = RetrieveCategoriesFromCacheAdapter()
    var getRestaurant: GetRestaurant = GetRestaurantAdapter()
    var isAppRunningOnPhone: IsAppRunningOnPhone = IsAppRunningOnPhoneAdapter()
  }
  private let dependencies: Dependencies
  @Published private(set) var restaurant: Restaurant?
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
    dependencies.retrieveCategories.execute()
  }
  
  func handleURL(_ url: URL) {
    guard
      url.scheme == DeepLink.scheme,
      url.lastPathComponent == DeepLink.restaurantDetailPath
    else { return }
    let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true)
    if let restaurantID = components?.queryItems?.first(where: { $0.name == DeepLink.restaurantIDQueryItem })?.value {
      self.restaurant = dependencies.getRestaurant.execute(for: restaurantID)
    }
  }
  
  func isAppOnPhone() -> Bool {
    return dependencies.isAppRunningOnPhone.execute()
  }
}
