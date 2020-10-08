//
//  CategoriesView.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-10-06.
//

import SwiftUI

struct CategoriesView: View {
  @ObservedObject var viewModel: CategoriesViewModel
  var body: some View {
    let contentHeight: CGFloat = 100.0
    NavigationView {
      VStack {
        List(viewModel.items, children: \.children) { row in
          let item = row.item
          if let categoryViewModel = item as? CategoryViewModel {
            CategoryRow(viewModel: categoryViewModel)
          } else if let restaurantViewModel = item as? RestaurantViewModel {
            RestaurantRow(viewModel: restaurantViewModel)
              .frame(height: contentHeight)
              .modifier(SwipeableModifier(
                          leadingActions: [SwipeAction(
                                            title: "Rate",
                                            iconName: "star.fill",
                                            onTap: { self.viewModel.rate(restaurant: restaurantViewModel) })],
                          contentHeight: contentHeight)
              )
          }
        }
      }
    }
    .onAppear {
      self.viewModel.updateCategories()
    }
  }
}

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

struct CategoriesView_Previews: PreviewProvider {
  static var previews: some View {
    let restaurantService = MockRestaurantService()
    restaurantService.categories = mockCategories
    let dependencies = CategoriesViewModel.Dependencies(restaurantService: restaurantService)
    return CategoriesView(viewModel: CategoriesViewModel(dependencies: dependencies))
  }
  
  private static var mockCategories: [RestaurantCategory] {
    return [
      RestaurantCategory(name: "Lunch", iconImageName: "cross.fill", restaurants: [
        Restaurant(restaurantID: "1", name: "McD", description: "Some normal food", imageName: "restaurant1", ratings: []),
        Restaurant(restaurantID: "2", name: "McE", description: "Some great food", imageName: "restaurant2", ratings: []),
        Restaurant(restaurantID: "3", name: "McC", description: "Some so so food", imageName: "restaurant3", ratings: []),
      ]),
      RestaurantCategory(name: "Dinning", iconImageName: "pencil.slash", restaurants: [
        Restaurant(restaurantID: "4", name: "McS", description: "Some normal food", imageName: "restaurant4", ratings: []),
        Restaurant(restaurantID: "5", name: "McT", description: "Some great food", imageName: "restaurant5", ratings: []),
        Restaurant(restaurantID: "6", name: "McR", description: "Some so so food", imageName: "restaurant3", ratings: []),
      ])
    ]
  }
}

private final class MockRestaurantService: RestaurantService {
  var categories: [RestaurantCategory] = []
  
  func getCategories(completion: @escaping ([RestaurantCategory]) -> Void) {
    completion(categories)
  }
}

