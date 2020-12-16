//
//  TabBarView.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-12-15.
//

import SwiftUI

struct TabBarView: View {
  var body: some View {
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
    }
  }
}

struct TabBarView_Previews: PreviewProvider {
  static var previews: some View {
    TabBarView()
  }
}
