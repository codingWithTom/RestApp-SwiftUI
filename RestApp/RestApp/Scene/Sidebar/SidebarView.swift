//
//  SidebarView.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-12-15.
//

import SwiftUI

struct SidebarView: View {
  
  @State private var selectedDestination: Destination? = .restaurants
  @State private var selectedFavorite: Restaurant? = nil
  @State private var isPresentingRestaurant: Bool = false {
    didSet {
      if !isPresentingRestaurant {
        selectedFavorite = nil
      }
    }
  }
  @State private var isPresentingRestaurantFromNotification: Bool = false
  @StateObject private var categoriesViewModel = CategoriesViewModel()
  @ObservedObject private var viewModel = SidebarViewModel()
  
  var body: some View {
    NavigationView {
      List {
        Section(header: Text("Browse")) {
          ForEach(Destination.allCases) { item in
            NavigationLink(destination: view(for: selectedDestination), tag: item, selection: $selectedDestination) {
              Label(item.title, systemImage: item.systemImageName).tag(item)
            }
          }
        }
        Section(header: Text("Favorites")) {
          if viewModel.favorites.isEmpty {
            ForEach(0 ..< 1) { _ in
              Text("Drop a Restaurant here")
            }
            .onInsert(of: [.data], perform: { _, items in self.viewModel.addFavoriteFromItems(items) })
          } else {
            ForEach(viewModel.favorites) { restaurant in
              Label(restaurant.name, systemImage: "suit.heart")
                .onTapGesture {
                  self.selectedFavorite = restaurant
                  self.isPresentingRestaurant.toggle()
              }
                .foregroundColor(selectedFavorite == restaurant ? .blue : .black)
            }
            .onInsert(of: [.data], perform: { _, items in self.viewModel.addFavoriteFromItems(items) })
            .onDelete(perform: { indexSet in self.viewModel.removeFrom(indexSet: indexSet) })
          }
        }
      }.listStyle(SidebarListStyle())
      view(for: selectedDestination)
      if selectedDestination == .restaurants {
        RestaurantView(restaurant: Restaurant.empty)
      }
    }.sheet(isPresented: $isPresentingRestaurant, onDismiss: { isPresentingRestaurant = false }) {
      NavigationView {
        RestaurantView(restaurant: selectedFavorite ?? .empty)
      }
    }
    .sheet(isPresented: $isPresentingRestaurantFromNotification) {
      NavigationView {
        RestaurantView(restaurant: viewModel.presentedRestaurant ?? .empty)
      }
    }
    .onReceive(viewModel.$presentedRestaurant) { presentedRestaurant in
      self.isPresentingRestaurantFromNotification = presentedRestaurant != nil
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
