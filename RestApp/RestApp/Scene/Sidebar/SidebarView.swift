//
//  SidebarView.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-12-15.
//

import SwiftUI

struct SidebarView: View {
  
  @State private var selectedDestination: Destination? = .restaurants
  @StateObject private var categoriesViewModel = CategoriesViewModel()
  
  var body: some View {
    NavigationView {
      List(Destination.allCases, selection: $selectedDestination) { item in
        NavigationLink(destination: view(for: selectedDestination), tag: item, selection: $selectedDestination) {
          Label(item.title, systemImage: item.systemImageName).tag(item)
        }
      }.listStyle(SidebarListStyle())
      view(for: selectedDestination)
      if selectedDestination == .restaurants {
        RestaurantView(restaurant: Restaurant.empty)
      }
    }
  }
  
  @ViewBuilder
  func view(for destination: Destination?) -> some View {
    switch destination {
    case .some(.restaurants):
      CategoriesView(viewModel: categoriesViewModel)
    case .some(.profile):
      ProfileView()
    default:
      EmptyView()
    }
  }
}

struct SidebarView_Previews: PreviewProvider {
  static var previews: some View {
    SidebarView()
  }
}
