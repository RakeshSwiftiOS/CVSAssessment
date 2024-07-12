//
//  Environment.swift
//  SearchFlickrImages
//
//  Created by Rakesh on 7/12/24.
//

import Foundation

enum Environment {
    private struct Paths {
        static let BasePath = "https://api.flickr.com/services/feeds/photos_public.gne"
    }
    
    case search(_ tags: String)
    
    var request: URLRequest? {
        switch self {
        case .search(let tags):
            guard var components = URLComponents(string: Paths.BasePath) else { return nil }
            components.queryItems = [
                URLQueryItem(name: "format", value: "json"),
                URLQueryItem(name: "nojsoncallback", value: "1"),
                URLQueryItem(name: "tags", value: tags),
            ]
            guard let url = components.url else { return nil }
            return URLRequest(url: url)
        }
    }
    
}
