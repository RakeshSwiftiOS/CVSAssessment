//
//  FlickrImage.swift
//  SearchFlickrImages
//
//  Created by Rakesh on 7/12/24.
//

import Foundation

struct FlickrWrapper: Decodable {
    let items: [FlickrImage]
}

struct FlickrImage: Decodable, Hashable {
    let title: String
    let link: String
    let media: Media
    let dateTaken: String
    let description: String
    let published: String
    let author: String
    let authorId: String
    let tags: String
    
    enum CodingKeys: String, CodingKey {
        case dateTaken = "date_taken"
        case authorId = "author_id"
        case title, link, media, description
        case published, author, tags
    }
}

struct Media: Decodable, Hashable {
    let m: String
}
