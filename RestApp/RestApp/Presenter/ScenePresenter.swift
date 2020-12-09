//
//  ScenePresenter.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-11-04.
//

import UIKit

extension RestaurantCategory {
  var viewModel: CategoryViewModel {
    return CategoryViewModel(categoryID: categoryID, name: name, icon: iconImageName)
  }
}

extension Restaurant {
  var viewModel: RestaurantViewModel {
    return RestaurantViewModel(restaurantID: restaurantID, name: name, description: description, imageName: imageName, labels: dishTypes.map(label(for:)))
  }
  
  private func label(for dishType: DishType) -> (text: String, color: UIColor) {
    switch dishType {
    case .vegan:
      return (text: "Vg", color: UIColor(red: 69 / 255, green: 123 / 255, blue: 157 / 255, alpha: 1.0))
    case .vegetarian:
      return (text: "Veg", color: UIColor(red: 0 / 255, green: 109 / 255, blue: 119 / 255, alpha: 1.0))
    case .glutenFree:
      return (text: "GF", color: UIColor(red: 228 / 255, green: 37 / 255, blue: 53 / 255, alpha: 1.0))
    default:
      return (text: "", color: .clear)
    }
  }
}

extension Rating {
  var viewModel: RatingViewModel {
    return RatingViewModel(ratingID: ratingID, score: Int(score) ?? 0, comment: comment)
  }
}
