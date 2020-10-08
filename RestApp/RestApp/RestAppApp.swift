//
//  RestAppApp.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-10-06.
//

import SwiftUI

@main
struct RestAppApp: App {
  var body: some Scene {
    WindowGroup {
      CategoriesView(viewModel: CategoriesViewModel())
    }
  }
}
