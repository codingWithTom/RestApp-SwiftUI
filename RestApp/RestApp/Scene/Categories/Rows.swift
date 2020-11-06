//
//  Rows.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-11-04.
//

import SwiftUI

struct CategoryRow: View {
  let viewModel: CategoryViewModel
  var body: some View {
    HStack {
      Image(systemName: viewModel.icon)
        .foregroundColor(.blue)
      Text(viewModel.name)
    }
  }
}

struct RestaurantRow: View {
  let viewModel: RestaurantViewModel
  
  var body: some View {
    GeometryReader { geometry in
      HStack {
        Image(viewModel.imageName)
          .resizable()
          .frame(width: geometry.size.height)
          .aspectRatio(contentMode: .fit)
        VStack(alignment: .leading) {
          Text(viewModel.name)
          Spacer()
          Text(viewModel.description)
            .font(.caption)
        }
        .padding(.vertical)
      }
    }
  }
}

struct RatingRow: View {
  let viewModel: RatingViewModel
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8.0) {
      ScoreView(score: viewModel.score)
      Text(viewModel.comment)
    }
  }
}
