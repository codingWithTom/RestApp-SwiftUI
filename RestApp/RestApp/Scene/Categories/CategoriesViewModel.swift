//
//  CategoriesViewModel.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-10-06.
//

import Foundation

struct RowItem: Identifiable {
  let item: Item
  let children: [RowItem]?
  
  var id: String { return item.id }
}

protocol Item {
  var id: String { get }
}

struct CategoryViewModel: Item {
  let name: String
  let icon: String
  var id: String { return name }
}

struct RestaurantViewModel: Item {
  let restaurantID: String
  let name: String
  let description: String
  let imageName: String
  var id: String { return restaurantID }
}

final class CategoriesViewModel: ObservableObject {
  struct Dependencies {
    var restaurantService: RestaurantService = RestaurantServiceAdapter.shared
  }
  private let dependencies: Dependencies
  @Published var items: [RowItem] = []
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
  }
  
  func updateCategories() {
    dependencies.restaurantService.getCategories { [weak self] categories in
      let rowItems = categories.map { RowItem(
        item: $0.viewModel,
        children: $0.restaurants.map { restaurant in RowItem(item: restaurant.viewModel, children: nil) }
      )}
      DispatchQueue.main.async {
        self?.items = rowItems
      }
    }
  }
  
  func rate(restaurant: RestaurantViewModel) {
    print("Rated: \(restaurant.name)")
  }
}

private extension RestaurantCategory {
  var viewModel: CategoryViewModel {
    return CategoryViewModel(name: name, icon: iconImageName)
  }
}

private extension Restaurant {
  var viewModel: RestaurantViewModel {
    return RestaurantViewModel(restaurantID: restaurantID, name: name, description: description, imageName: imageName)
  }
}
