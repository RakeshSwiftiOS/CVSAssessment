//
//  MockSession.swift
//  SearchFlickrImagesUITests
//
//  Created by Rakesh on 7/12/24.
//

import Foundation
import Combine
@testable import SearchFlickrImages

class MockURLSession: Session {
    func fetchData(with request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), Error> {
        let urlStr = request.url?.absoluteString ?? "Fail"
        
        if urlStr.contains("StatusCodeFailure") {
            
            let data = Data()
            let response = HTTPURLResponse(url: request.url!, statusCode: 404, httpVersion: nil, headerFields: nil)!
            
            return Just((data: data, response: response))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else if urlStr.contains("DecodeFailure") {
            let sampleJSON = """
                            {
                                "test": "This should fail"
                            }
                            """
            let data = sampleJSON.data(using: .utf8)!
            
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            
            return Just((data: data, response: response))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else if urlStr.contains("GeneralFailure") {
            return Fail(error: NetworkError.other(NSError(domain: "General Error", code: 222))).eraseToAnyPublisher()
        } else { // Success Path
            guard let path = Bundle(for: SearchFlickrImagesUITests.self).path(forResource: "FlickrSampleResponse", ofType: "json") else {
                return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
            }
            
            let url = URL(filePath: path)
            
            do {
                let data = try Data(contentsOf: url)
                
                let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
                
                return Just((data: data, response: response))
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
                
            } catch {
                print(error)
            }
            
            
        }
        
        return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
    }
}
