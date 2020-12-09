//
//  SearchBar.swift
//  RestApp
//
//  Created by Tomas Trujillo on 2020-12-08.
//

import SwiftUI

struct SearchBar: UIViewRepresentable {
  @Binding var text: String
  let placeholder: String
  
  func makeCoordinator() -> SearchCoordinator {
    return SearchCoordinator(text: $text)
  }
  
  func makeUIView(context: Context) -> UISearchBar {
    let searchBar = UISearchBar()
    searchBar.delegate = context.coordinator
    searchBar.placeholder = placeholder
    return searchBar
  }
  
  func updateUIView(_ uiView: UISearchBar, context: Context) { }
}

final class SearchCoordinator: NSObject, UISearchBarDelegate {
  @Binding var text: String
  
  init(text: Binding<String>) {
    self._text = text
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    text = searchText
  }
}
