//
//  CategoriesView.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-10-06.
//

import SwiftUI

struct CategoriesView: View {
  @ObservedObject var viewModel: CategoriesViewModel
  @Environment(\.presentationMode) var presentationMode
  @State private var isPresentingRateView: Bool = false
  @State private var ratedRestaurantID: String = ""
  @State private var isPresentingShareView: Bool = false
  @State private var shareRestaurantID: String = ""
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
            else if let restaurantViewModel = item as? RestaurantViewModel,
                    let restaurant = viewModel.getRestaurant(for: restaurantViewModel.id) {
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
        if isPresentingRateView {
          RateView(isPresenting: $isPresentingRateView, restaurantID: ratedRestaurantID)
            .transition(.opacity)
        }
      }
    }
    .onAppear {
      self.viewModel.handleSceneAppeared()
    }
    .sheet(isPresented: $isPresentingShareView, content: {
      ActivityController(activityItems: self.viewModel.getShareableItems(for: shareRestaurantID))
    })
  }
}

struct CategoriesView_Previews: PreviewProvider {
  static var previews: some View {
    let restaurantService = MockRestaurantService()
    let dependencies = CategoriesViewModel.Dependencies(restaurantService: restaurantService)
    return CategoriesView(viewModel: CategoriesViewModel(dependencies: dependencies))
  }
}
