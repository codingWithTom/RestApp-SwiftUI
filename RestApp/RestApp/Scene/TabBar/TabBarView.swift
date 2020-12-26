//
//  TabBarView.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-12-15.
//

import SwiftUI

struct TabBarView: View {
  
  @ObservedObject private var viewModel = TabBarViewModel()
  @State private var restaurant = Restaurant.empty
  @State private var isPresentingRestaurant: Bool = false
  
  var body: some View {
    GeometryReader { geometry in
      ZStack {
        TabView {
          NavigationView {
            CategoriesView(viewModel: .init())
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
          NavigationView {
            FavoritesView()
          }
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
      self.restaurant = restaurant
      self.isPresentingRestaurant = true
    })
    .sheet(isPresented: $isPresentingRestaurant, content: {
      NavigationView {
        RestaurantView(restaurant: viewModel.presentedRestaurant ?? .empty)
      }
    })
  }
}

struct TabBarView_Previews: PreviewProvider {
  static var previews: some View {
    TabBarView()
      .environmentObject(RestaurantAppViewModel())
  }
}
