//
//  RestAppApp.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-10-06.
//

import SwiftUI

@main
struct RestAppApp: App {
  
  @StateObject private var viewModel = RestaurantAppViewModel()
  
  var body: some Scene {
    WindowGroup {
      CategoriesView(viewModel: CategoriesViewModel())
        .environmentObject(viewModel)
        .onOpenURL(perform: viewModel.handleURL(_:))
    }
  }
}
