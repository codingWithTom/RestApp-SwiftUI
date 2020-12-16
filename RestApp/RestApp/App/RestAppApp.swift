//
//  RestAppApp.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-10-06.
//

import SwiftUI

enum Destination: CaseIterable, Identifiable {
  case restaurants
  case profile
  
  var id: String { return title }
  
  var title: String {
    switch self {
    case .restaurants: return "Restaurants"
    case .profile: return "Profile"
    }
  }
  
  var systemImageName: String {
    switch self {
    case .restaurants: return "list.bullet.rectangle"
    case .profile: return "person.circle.fill"
    }
  }
}

@main
struct RestAppApp: App {
  
  @StateObject private var viewModel = RestaurantAppViewModel()
  
  var body: some Scene {
    WindowGroup {
      mainView()
        .environmentObject(viewModel)
        .onOpenURL(perform: viewModel.handleURL(_:))
    }
  }
  
  @ViewBuilder
  func mainView() -> some View {
    if viewModel.isAppOnPhone() {
      TabBarView()
    } else {
      SidebarView()
    }
  }
}
