//
//  CategoriesList.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-12-10.
//

import SwiftUI

struct CategoriesList: View {
  
  @ObservedObject var viewModel: CategoriesViewModel
  @Binding var isPresentingRateView: Bool
  @Binding var isPresentingShareView: Bool
  @Binding var shareRestaurantID: String
  @Binding var ratedRestaurantID: String
  
  var body: some View {
    List(viewModel.items, children: \.children) { row in
      let item = row.item
      if let categoryViewModel = item as? CategoryViewModel {
        CategoryRow(viewModel: categoryViewModel)
      } else if let ratingViewModel = item as? RatingViewModel {
        RatingRow(viewModel: ratingViewModel)
      }
      else if let restaurantViewModel = item as? RestaurantViewModel,
              let restaurant = viewModel.getRestaurant(for: restaurantViewModel.id) {
        RestaurantItem(isPresentingRateView: $isPresentingRateView, ratedRestaurantID: $ratedRestaurantID,
                       restaurantViewModel: restaurantViewModel, restaurant: restaurant)
        .contextMenu(ContextMenu(menuItems: {
          Button(action: {
            ratedRestaurantID = restaurantViewModel.restaurantID
            withAnimation {
              isPresentingRateView.toggle()
            }
          }, label: {
            Image(systemName: "star.fill")
            Text("Rate")
          })
          Button(action: {
            self.shareRestaurantID = restaurantViewModel.restaurantID
            withAnimation {
              isPresentingShareView.toggle()
            }
          }, label: {
            Image(systemName: "square.and.arrow.up")
            Text("Share")
          })
        }))
      }
    }
  }
}

private struct RestaurantItem: View {
  
  @Binding var isPresentingRateView: Bool
  @Binding var ratedRestaurantID: String
  let restaurantViewModel: RestaurantViewModel
  let restaurant: Restaurant
  private let contentHeight: CGFloat = 100
  
  var body: some View {
    ZStack {
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
      NavigationLink(destination: RestaurantView(restaurant: restaurant)) {
        EmptyView()
      }.buttonStyle(PlainButtonStyle())
    }
  }
}
