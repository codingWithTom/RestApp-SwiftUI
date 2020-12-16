//
//  CategoriesViewModel.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-10-06.
//

import UIKit
import Combine

struct RowItem: Identifiable, Hashable {
  let item: Item
  let children: [RowItem]?
  
  var id: String { return item.id }
  
  static func ==(rhs: RowItem, lhs: RowItem) -> Bool {
    return rhs.id == lhs.id
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
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
  let labels: [(text: String, color: UIColor)]
  var id: String { return restaurantID }
  
  static func ==(lhs: RestaurantViewModel, rhs: RestaurantViewModel) -> Bool {
    return lhs.id == rhs.id
  }
}

struct RatingViewModel: Item {
  let ratingID: String
  let score: Int
  let comment: String
  var id: String { return ratingID }
}

final class CategoriesViewModel: ObservableObject {
  struct Dependencies {
    var fetchCategories: FetchCategories = FetchCategoriesAdapter()
    var getShareableInfo: GetShareableInfo = GetShareableInfoAdapter()
    var getRestaurant: GetRestaurant = GetRestaurantAdapter()
    var getCategoriesPublisher: GetCategoriesPublisher = GetCategoriesPublisherAdapter()
  }
  private let dependencies: Dependencies
  private var categoriesCancellable: AnyCancellable?
  @Published var items: [RowItem] = []
  @Published var searchText: String = "" {
    didSet {
      dependencies.getCategoriesPublisher.updateSearchFor(text: searchText, dishType: DishType.allCases[selectedSearchScopeIndex])
    }
  }
  @Published var selectedSearchScopeIndex: Int = 0 {
    didSet {
      dependencies.getCategoriesPublisher.updateSearchFor(text: searchText, dishType: DishType.allCases[selectedSearchScopeIndex])
    }
  }
  
  init(dependencies: Dependencies = .init()) {
    print("Viewmodel init!")
    self.dependencies = dependencies
    self.subscribeToPublisher()
  }
  
  func handleSceneAppeared() {
    dependencies.fetchCategories.execute()
  }
  
  func getRestaurant(for restaurantID: String) -> Restaurant? {
    return dependencies.getRestaurant.execute(for: restaurantID)
  }
  
  func getShareableItems(for restaurantID: String) -> [Any] {
    guard let restaurant = dependencies.getRestaurant.execute(for: restaurantID) else { return [] }
    return dependencies.getShareableInfo.execute(for: restaurant)
  }
}

private extension CategoriesViewModel {
  func subscribeToPublisher() {
    self.categoriesCancellable = dependencies.getCategoriesPublisher.execute().map { categories in
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
