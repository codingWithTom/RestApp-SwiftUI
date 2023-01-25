//
//  TabBarView.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-12-15.
//

import SwiftUI

struct TabBarView: View {
  @EnvironmentObject private var appModel: RestaurantAppViewModel
  @ObservedObject private var viewModel = TabBarViewModel()
  @StateObject private var categoriesViewModel = CategoriesViewModel()
  @State private var path: [Restaurant] = []
  
  var body: some View {
    GeometryReader { geometry in
      ZStack {
        TabView {
          NavigationStack(path: $path) {
            CategoriesView(viewModel: categoriesViewModel)
              .onReceive(categoriesViewModel.$selectedRestaurant) { restaurant in
                guard let restaurant else { return }
                path = [restaurant]
              }
              .navigationDestination(for: Restaurant.self) { restaurant in
                RestaurantView(restaurant: restaurant)
              }
          }
          .tabItem {
            Text(Destination.restaurants.title)
            Image(systemName: Destination.restaurants.systemImageName)
          }
          NavigationView {
            ProfileView()
          }
          .tabItem {
            Text(Destination.profile.title)
            Image(systemName: Destination.profile.systemImageName)
          }
          FavoritesView()
          .tabItem {
            Text("Favorites")
            Image(systemName: "suit.heart")
          }
        }
        if viewModel.numberOfFavorites > 0 {
          Text("\(viewModel.numberOfFavorites)")
            .padding(4)
            .foregroundColor(.white)
            .font(.caption)
            .background(Circle().foregroundColor(Color(.systemRed)))
            .offset(x: (geometry.size.width / 3) + (geometry.size.width * 0.05),
                    y: (geometry.size.height * 0.9) / 2)
            .transition(.scale)
        }
      }
    }
    .onReceive(viewModel.$presentedRestaurant, perform: { presentedRestaurant in
      guard let restaurant = presentedRestaurant else { return }
      self.path = [restaurant]
    })
    .onReceive(appModel.$restaurant) { restaurant in
      guard let restaurant else { return }
      self.path = [restaurant, restaurant, restaurant]
    }
  }
}

struct TabBarView_Previews: PreviewProvider {
  static var previews: some View {
    TabBarView()
      .environmentObject(RestaurantAppViewModel())
  }
}
