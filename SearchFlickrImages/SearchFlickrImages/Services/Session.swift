//
//  Session.swift
//  SearchFlickrImages
//
//  Created by Rakesh on 7/12/24.
//

import Foundation
import Combine

protocol Session {
    func fetchData(with request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), Error>
}

extension URLSession: Session {
    func fetchData(with request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), Error> {
        self.dataTaskPublisher(for: request)
            .mapError({ urlError in
                return urlError as Error
            }).eraseToAnyPublisher()
    }
}
