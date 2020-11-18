//
//  RestaurantImageView.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-11-17.
//

import SwiftUI

struct RestaurantImageView: View {
  let imagePlaceholder: String
  let loader: (@escaping (UIImage?) -> Void) -> Void
  @State private var image: UIImage?
  
  var imageToShow: UIImage {
    if let loadedImage = image {
      return loadedImage
    } else {
      return UIImage(named: imagePlaceholder)!
    }
  }
  
  var body: some View {
    Image(uiImage: imageToShow)
      .resizable()
      .aspectRatio(contentMode: .fill)
      .onAppear {
        loader {
          self.image = $0
        }
      }
  }
}

struct RestaurantImageView_Previews: PreviewProvider {
  static var previews: some View {
    RestaurantImageView(imagePlaceholder: "foodPlaceholder") { closure in
      closure(UIImage(named: "restaurant1"))
    }
  }
}
