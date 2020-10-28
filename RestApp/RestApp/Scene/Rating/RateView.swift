//
//  RateView.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-10-26.
//

import SwiftUI

struct RateView: View {
  let viewModel: RateViewModel
  @State private var score: Int = 3
  @State private var comment: String = ""
  @Binding var isPresenting: Bool
  let restaurantID: String
  
  init(viewModel: RateViewModel = .init(), isPresenting: Binding<Bool>, restaurantID: String) {
    self.viewModel = viewModel
    self._isPresenting = isPresenting
    self.restaurantID = restaurantID
  }
  
  var body: some View {
    ZStack {
      Rectangle()
        .fill(Color.black.opacity(0.3))
        .onTapGesture {
          isPresenting.toggle()
        }
      VStack {
        ScoreView(score: score)
        Stepper("Enter score", onIncrement: { score = min(score + 1, 5) }, onDecrement: {score = max(score - 1, 0)})
        TextField("Leave your comment", text: $comment)
          .textFieldStyle(RoundedBorderTextFieldStyle())
        HStack(spacing: 20.0) {
          Button("Cancel"){ isPresenting.toggle() }
          Button("Rate"){
            viewModel.rate(restaurantID: restaurantID, score: score, comment: comment)
            isPresenting.toggle()
          }
        }
      }
      .clipShape(Rectangle())
      .background(Color.white)
      .cornerRadius(10)
      .padding()
    }
  }
}

struct RateView_Previews: PreviewProvider {
  static var previews: some View {
    RateView(isPresenting: .constant(false), restaurantID: "1")
  }
}
