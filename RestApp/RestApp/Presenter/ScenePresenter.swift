//
//  ScenePresenter.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-11-04.
//

import Foundation

extension RestaurantCategory {
  var viewModel: CategoryViewModel {
    return CategoryViewModel(categoryID: categoryID, name: name, icon: iconImageName)
  }
}

extension Restaurant {
  var viewModel: RestaurantViewModel {
    return RestaurantViewModel(restaurantID: restaurantID, name: name, description: description, imageName: imageName)
  }
}

extension Rating {
  var viewModel: RatingViewModel {
    return RatingViewModel(ratingID: ratingID, score: Int(score) ?? 0, comment: comment)
  }
}
