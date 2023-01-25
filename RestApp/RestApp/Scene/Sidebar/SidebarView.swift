//
//  SidebarView.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-12-15.
//

import SwiftUI

struct SidebarView: View {
  
  @State private var selectedDestination: Destination? = .restaurants
  @State private var selectedRestaurant: Restaurant? = nil
  @State private var isPresentingRestaurant: Bool = false {
    didSet {
      if !isPresentingRestaurant {
        selectedRestaurant = nil
      }
    }
  }
  @State private var isPresentingRestaurantFromNotification: Bool = false
  @StateObject private var categoriesViewModel = CategoriesViewModel()
  @ObservedObject private var viewModel = SidebarViewModel()
  @State private var columnVisibility: NavigationSplitViewVisibility = .all
  
  var body: some View {
    NavigationSplitView(columnVisibility: $columnVisibility) {
      List(selection: $selectedDestination) {
        Section(header: Text("Browse")) {
          ForEach(Destination.allCases) { item in
            NavigationLink(value: item) {
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
                  self.selectedRestaurant = restaurant
                  self.isPresentingRestaurant.toggle()
                }
                .foregroundColor(selectedRestaurant == restaurant ? .blue : .black)
            }
            .onInsert(of: [.data], perform: { _, items in self.viewModel.addFavoriteFromItems(items) })
            .onDelete(perform: { indexSet in self.viewModel.removeFrom(indexSet: indexSet) })
          }
        }
      }.listStyle(SidebarListStyle())
    } content: {
      view(for: selectedDestination)
    } detail: {
      RestaurantView(restaurant: selectedRestaurant ?? Restaurant.empty)
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
        .onReceive(categoriesViewModel.$selectedRestaurant) {
          selectedRestaurant = $0
          columnVisibility = .doubleColumn
        }
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
