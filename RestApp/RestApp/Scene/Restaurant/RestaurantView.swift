//
//  RestaurantView.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-11-04.
//

import SwiftUI

struct RestaurantView: View {
  let viewModel: RestaurantDetailViewModel
  @State private var isShowingShareActivity = false
  @State private var selectedSemgnetIndex: Int = 0
  
  init(restaurant: Restaurant) {
    self.viewModel = RestaurantDetailViewModel(restaurant: restaurant)
  }
  
  var body: some View {
    GeometryReader { geometry in
      VStack {
        Image(viewModel.restaurantImageName)
          .resizable()
        Text(viewModel.restaurantDescription)
        Picker("", selection: $selectedSemgnetIndex) {
          Text("Ratings").tag(0)
          Text("Images").tag(1)
        }.pickerStyle(SegmentedPickerStyle())
        .padding()
        if selectedSemgnetIndex == 0 {
          List(viewModel.getRatings(), id: \.self.id) { rating in
            RatingRow(viewModel: rating)
          }
        } else {
          ScrollView {
            LazyVGrid(columns: [GridItem(.fixed(geometry.size.width / 2.0)), GridItem(.fixed(geometry.size.width / 2.0))]) {
              ForEach(viewModel.getImageItems(), id: \.self.id) { imageVM in
                RestaurantImageView(imagePlaceholder: imageVM.placeholder, loader: imageVM.loader)
                  .frame(height: geometry.size.width / 2.0 * 0.66)
                  .clipped()
              }
            }
          }
        }
      }
      .navigationTitle(viewModel.title)
      .navigationBarItems(trailing:
                            Button(action: {
                              isShowingShareActivity.toggle()
                            }, label: {
                              Image(systemName: "square.and.arrow.up")
                            })
      )
      .sheet(isPresented: $isShowingShareActivity, content: {
        let items: [Any] = viewModel.getShareableItems()
        ActivityController(activityItems: items)
    })
    }
  }
}

struct RestaurantView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      RestaurantView(restaurant: Restaurant(restaurantID: "1", name: "Some Restaurant", description: "On Cupertino Park", imageName: "restaurant1", ratings: [
        Rating(ratingID: "1", score: "1", comment: "Delicious food"),
        Rating(ratingID: "2", score: "2", comment: "Delicious food"),
        Rating(ratingID: "3", score: "3", comment: "Delicious food"),
        Rating(ratingID: "4", score: "4", comment: "Delicious food"),
        Rating(ratingID: "5", score: "5", comment: "Delicious food")
      ], images: [], dishTypes: []))
    }
  }
}
