//
//  FavoritesView.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-12-21.
//

import SwiftUI

struct FavoritesView: View {
  
  @ObservedObject private var viewModel = FavoritesViewModel()
  
  var body: some View {
    List {
      ForEach(viewModel.favorites) { restaurant in
        NavigationLink(destination: RestaurantView(restaurant: restaurant)) {
          RestaurantRow(viewModel: restaurant.viewModel)
            .frame(height: 100)
        }
      }
      .onDelete(perform: { indexSet in self.viewModel.removeFrom(indexSet: indexSet) })
    }
    .navigationTitle("Favorites")
  }
}

struct FavoritesView_Previews: PreviewProvider {
  static var previews: some View {
    FavoritesView()
  }
}
