//
//  NetworkService.swift
//  SearchFlickrImages
//
//  Created by Rakesh on 7/12/24.
//

import Foundation
import Combine

protocol Network {
    func fetchData<T: Decodable>(with request: URLRequest?) -> AnyPublisher<T, NetworkError>
}

class NetworkService: Network {
    let session: Session
    let decoder: JSONDecoder

    init(session: Session = URLSession.shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }
    
    func fetchData<T>(with request: URLRequest?) -> AnyPublisher<T, NetworkError> where T : Decodable {
        guard let request = request else {
            return Fail(error: NetworkError.badRequest).eraseToAnyPublisher()
        }
        
        return session.fetchData(with: request)
            .tryMap { payload in
                if let httpResponse = payload.response as? HTTPURLResponse,
                   !(200..<300).contains(httpResponse.statusCode) {
                    throw NetworkError.badStatusCode(httpResponse.statusCode)
                }
                return payload.data
            }.decode(type: T.self, decoder: decoder)
            .mapError { error in
                if let decodeErr = error as? DecodingError {
                    return NetworkError.decodeError(decodeErr)
                } else if let networkError = error as? NetworkError {
                    return networkError
                }
                return NetworkError.other(error)
            }.eraseToAnyPublisher()
    }
}
