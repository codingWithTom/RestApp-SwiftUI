//
//  ScoreView.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-10-26.
//

import SwiftUI

struct ScoreView: View {
  let score: Int
  var body: some View {
    HStack {
      ForEach(0 ..< score, id: \.self) { _ in
        Image(systemName: "star.fill")
      }
      ForEach(score ..< 5, id: \.self) { _ in
        Image(systemName: "star")
      }
    }
    .foregroundColor(.yellow)
  }
}

struct ScoreView_Previews: PreviewProvider {
  static var previews: some View {
    ScoreView(score: 3)
  }
}
