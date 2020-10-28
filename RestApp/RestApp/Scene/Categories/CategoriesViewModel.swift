//
//  CategoriesViewModel.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-10-06.
//

import Foundation
import Combine

struct RowItem: Identifiable {
  let item: Item
  let children: [RowItem]?
  
  var id: String { return item.id }
}

protocol Item {
  var id: String { get }
}

struct CategoryViewModel: Item {
  let categoryID: String
  let name: String
  let icon: String
  var id: String { return categoryID }
}

struct RestaurantViewModel: Item {
  let restaurantID: String
  let name: String
  let description: String
  let imageName: String
  var id: String { return restaurantID }
}

struct RatingViewModel: Item {
  let ratingID: String
  let score: Int
  let comment: String
  var id: String { return ratingID }
}

final class CategoriesViewModel: ObservableObject {
  struct Dependencies {
    var restaurantService: RestaurantService = RestaurantServiceAdapter.shared
  }
  private let dependencies: Dependencies
  private var categoriesCancellable: AnyCancellable?
  @Published var items: [RowItem] = []
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
    self.subscribeToPublisher()
  }
  
  func handleSceneAppeared() {
    dependencies.restaurantService.getCategories()
  }
}

private extension CategoriesViewModel {
  func subscribeToPublisher() {
    self.categoriesCancellable = dependencies.restaurantService.categoriesPublisher.map { categories in
      categories.map { category in
        RowItem(item: category.viewModel,
                children: category.restaurants.map { restaurant in
                  RowItem(item: restaurant.viewModel,
                          children: restaurant.ratings.count > 0 ? restaurant.ratings.map { RowItem(item: $0.viewModel, children: nil) } : nil)
                }
        )}
    }.receive(on: DispatchQueue.main)
    .assign(to: \.items, on: self)
  }
}

private extension RestaurantCategory {
  var viewModel: CategoryViewModel {
    return CategoryViewModel(categoryID: categoryID, name: name, icon: iconImageName)
  }
}

private extension Restaurant {
  var viewModel: RestaurantViewModel {
    return RestaurantViewModel(restaurantID: restaurantID, name: name, description: description, imageName: imageName)
  }
}

private extension Rating {
  var viewModel: RatingViewModel {
    return RatingViewModel(ratingID: ratingID, score: Int(score) ?? 0, comment: comment)
  }
}
