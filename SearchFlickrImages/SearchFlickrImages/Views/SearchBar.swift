//
//  SearchBar.swift
//  SearchFlickrImages
//
//  Created by Rakesh on 7/12/24.
//

import SwiftUI

struct SearchBar: UIViewRepresentable {
    @ObservedObject var viewModel: FlickrSearchViewModel
    
    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        
        init(text: Binding<String>) {
            _text = text
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $viewModel.searchQuery)
    }
    
    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = viewModel.searchQuery
    }
}
