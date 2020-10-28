//
//  CategoriesView.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-10-06.
//

import SwiftUI

struct CategoriesView: View {
  @ObservedObject var viewModel: CategoriesViewModel
  @State private var isPresentingRateView: Bool = false
  @State private var ratedRestaurantID: String = ""
  var body: some View {
    let contentHeight: CGFloat = 100.0
    NavigationView {
      ZStack {
        VStack {
          List(viewModel.items, children: \.children) { row in
            let item = row.item
            if let categoryViewModel = item as? CategoryViewModel {
              CategoryRow(viewModel: categoryViewModel)
            } else if let ratingViewModel = item as? RatingViewModel {
              RatingRow(viewModel: ratingViewModel)
            }
            else if let restaurantViewModel = item as? RestaurantViewModel {
              RestaurantRow(viewModel: restaurantViewModel)
                .frame(height: contentHeight)
                .modifier(SwipeableModifier(
                            leadingActions: [SwipeAction(
                                              title: "Rate",
                                              iconName: "star.fill",
                                              onTap: {
                                                ratedRestaurantID = restaurantViewModel.restaurantID
                                                withAnimation {
                                                  isPresentingRateView.toggle()
                                                }
                                              })],
                            contentHeight: contentHeight)
                )
            }
          }
        }
        if isPresentingRateView {
          RateView(isPresenting: $isPresentingRateView, restaurantID: ratedRestaurantID)
            .transition(.opacity)
        }
      }
    }
    .onAppear {
      self.viewModel.handleSceneAppeared()
    }
  }
}

struct CategoryRow: View {
  let viewModel: CategoryViewModel
  var body: some View {
    HStack {
      Image(systemName: viewModel.icon)
        .foregroundColor(.blue)
      Text(viewModel.name)
    }
  }
}

struct RestaurantRow: View {
  let viewModel: RestaurantViewModel
  
  var body: some View {
    GeometryReader { geometry in
      HStack {
        Image(viewModel.imageName)
          .resizable()
          .frame(width: geometry.size.height)
          .aspectRatio(contentMode: .fit)
        VStack(alignment: .leading) {
          Text(viewModel.name)
          Spacer()
          Text(viewModel.description)
            .font(.caption)
        }
        .padding(.vertical)
      }
    }
  }
}

struct RatingRow: View {
  let viewModel: RatingViewModel
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8.0) {
      ScoreView(score: viewModel.score)
      Text(viewModel.comment)
    }
  }
}

struct CategoriesView_Previews: PreviewProvider {
  static var previews: some View {
    let restaurantService = MockRestaurantService()
    let dependencies = CategoriesViewModel.Dependencies(restaurantService: restaurantService)
    return CategoriesView(viewModel: CategoriesViewModel(dependencies: dependencies))
  }
}
