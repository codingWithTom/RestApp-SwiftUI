//
//  TabBarView.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-12-15.
//

import SwiftUI

struct TabBarView: View {
  
  @ObservedObject private var viewModel = TabBarViewModel()
  
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
  }
}

struct TabBarView_Previews: PreviewProvider {
  static var previews: some View {
    TabBarView()
      .environmentObject(RestaurantAppViewModel())
  }
}
