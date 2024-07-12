//
//  ContentView.swift
//  SearchFlickrImages
//
//  Created by Rakesh on 7/12/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = FlickrSearchViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                SearchBar(viewModel: viewModel)
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    FlickrGridView(viewModel: viewModel)
                        .alert("Something Went Wrong\nTry Again Later", isPresented: $viewModel.hasError, actions: {
                            Button("Thanks") {
                                viewModel.hasError = false
                            }
                        })
                }
                Spacer()
            }
            .navigationTitle("Flickr Search")
        }
    }
}

#Preview {
    ContentView()
}
