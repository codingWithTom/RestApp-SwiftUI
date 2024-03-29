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
    ZStack {
      VStack {
        List(viewModel.items, children: \.children, selection: $viewModel.selectedRestaurant) { row in
          let item = row.item
          if let categoryViewModel = item as? CategoryViewModel {
            CategoryRow(viewModel: categoryViewModel)
          } else if let ratingViewModel = item as? RatingViewModel {
            RatingRow(viewModel: ratingViewModel)
          }
          else if let restaurantViewModel = item as? RestaurantViewModel,
                  let restaurant = viewModel.getRestaurant(for: restaurantViewModel.id) {
            
            NavigationLink(value: restaurant) {
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
            }.buttonStyle(PlainButtonStyle())
            .onDrag({ NSItemProvider(object: RestaurantDragItem(restaurant: restaurant)) })
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
                viewModel.addFavorite(restaurant)
              }, label: {
                Image(systemName: "suit.heart")
                Text("Add to Favorites")
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
    .navigationTitle("Restaurants")
    .overlay(SearchBar(text: $viewModel.searchText, selectedIndex: $viewModel.selectedSearchScopeIndex, placeholder: "Search for a Restaurant")
              .frame(width: 0.0, height: 0.0))
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
    return CategoriesView(viewModel: CategoriesViewModel())
  }
}
