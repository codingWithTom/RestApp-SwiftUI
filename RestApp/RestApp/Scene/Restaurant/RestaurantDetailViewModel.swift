//
//  RestaurantDetailViewModel.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-11-04.
//

import UIKit

struct RestaurantImageViewModel: Identifiable {
  let id = UUID()
  let placeholder: String
  let loader: (@escaping (UIImage?) -> Void) -> Void
}

final class RestaurantDetailViewModel {
  struct Dependencies {
    var getShareableInfo: GetShareableInfo = GetShareableInfoAdapter()
    var imageCache: ImageCacheService = ImageCacheServiceAdapter.shared
  }
  private let dependencies: Dependencies
  private let restaurant: Restaurant
  var restaurantImageName: String { return restaurant.imageName }
  var restaurantDescription: String { return restaurant.description }
  var title: String { return restaurant.name }
  
  init(dependencies: Dependencies = .init(), restaurant: Restaurant) {
    self.dependencies = dependencies
    self.restaurant = restaurant
  }
  
  func getRatings() -> [RatingViewModel] {
    return restaurant.ratings.map { $0.viewModel }
  }
  
  func getImageItems() -> [RestaurantImageViewModel] {
    return restaurant.images.map {
        RestaurantImageViewModel(
          placeholder: "foodPlaceholder",
          loader: getLoader(for: $0)
        )
    }
  }
  
  func getShareableItems() -> [Any] {
    return dependencies.getShareableInfo.execute(for: restaurant)
  }
}

private extension RestaurantDetailViewModel {
  func getLoader(for url: String) -> (@escaping (UIImage?) -> Void) -> Void {
    return { [weak self] loader in
      self?.dependencies.imageCache.getImage(from: url, completion: loader)
    }
  }
  
}
