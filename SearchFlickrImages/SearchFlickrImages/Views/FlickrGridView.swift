//
//  FlickrGridView.swift
//  SearchFlickrImages
//
//  Created by Rakesh on 7/12/24.
//

import SwiftUI

struct FlickrGridView: View {
    @ObservedObject var viewModel: FlickrSearchViewModel
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())],
                      content: {
                ForEach(viewModel.items, id: \.self) { item in
                    NavigationLink {
                        DetailView(item: item)
                    } label: {
                        AsyncImage(url: URL(string: item.media.m)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .frame(width: 100, height: 100, alignment: .center)
                                    .aspectRatio(contentMode: .fill)
                                    .modifier(RoundedEdge(width: 3, color: Color(uiColor: .label), cornerRadius: 5))
                            case .failure:
                                Image(systemName: "questionmark.app.fill")
                            @unknown default:
                                Image(systemName: "questionmark.app.fill")
                            }
                        }
                    }
                }
            })
        }
    }
}
