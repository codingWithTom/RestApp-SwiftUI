//
//  SearchBar.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-12-08.
//

import SwiftUI

struct SearchBar: UIViewControllerRepresentable {
  @Binding var text: String
  @Binding var selectedIndex: Int
  let placeholder: String
  
  func makeCoordinator() -> SearchCoordinator {
    return SearchCoordinator(text: $text, selectedIndex: $selectedIndex)
  }
  
  func makeUIViewController(context: Context) -> some UIViewController {
    context.coordinator.searchController.searchBar.placeholder = placeholder
    return WrapperSearchController()
  }
  
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    uiViewController.parent?.navigationItem.searchController = context.coordinator.searchController
  }
}

final class WrapperSearchController: UIViewController { }

final class SearchCoordinator: NSObject, UISearchBarDelegate, UISearchResultsUpdating {
  @Binding var text: String
  @Binding var selectedIndex: Int
  private(set) var searchController = UISearchController()
  
  init(text: Binding<String>, selectedIndex: Binding<Int>) {
    self._text = text
    self._selectedIndex = selectedIndex
    super.init()
    searchController.searchResultsUpdater = self
    searchController.searchBar.delegate = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.scopeButtonTitles = DishType.allCases.map { $0.rawValue }
  }
  
  func updateSearchResults(for searchController: UISearchController) {
    text = searchController.searchBar.text ?? ""
  }
  
  func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    selectedIndex = selectedScope
  }
}
