//
//  MockSession.swift
//  SearchFlickrImagesTests
//
//  Created by Rakesh on 7/12/24.
//

import XCTest
import Combine
@testable import SearchFlickrImages

final class NetworkManagerTests: XCTestCase {

    var networkService: NetworkService?
    private var subs = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        self.networkService = NetworkService(session: MockURLSession())
    }

    override func tearDownWithError() throws {
        self.networkService = nil
        try super.tearDownWithError()
    }

    func testNetworkFetchSuccess() {
        let expectation = XCTestExpectation(description: "Successfully fetched data")
        var flickrResults: [FlickrImage] = []
                
        self.networkService?.fetchData(with: MockEnvironment.success.request)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    XCTFail()
                case .finished:
                    print("Data Stream Closed")
                }
            }, receiveValue: { (flickr: FlickrWrapper) in
                flickrResults = flickr.items
                expectation.fulfill()
            })
            .store(in: &self.subs)
        
        wait(for: [expectation], timeout: 2)
        
        XCTAssertEqual(flickrResults.count, 20)
        XCTAssertEqual(flickrResults.first?.title, "San Stae - Saint Stae")
    }

    func testNetworkFetchRequestFail() {
        let expectation = XCTestExpectation(description: "Failed with a bad request")
        var failure: NetworkError?
        
        self.networkService?.fetchData(with: nil)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    failure = error
                    expectation.fulfill()
                case .finished:
                    XCTFail()
                }
            }, receiveValue: { (_: FlickrWrapper) in
                XCTFail()
            })
            .store(in: &self.subs)
        
        wait(for: [expectation], timeout: 2)
        
        XCTAssertEqual(failure, NetworkError.badRequest)
    }
    
    func testNetworkFetchStatusCodeFail() {
        let expectation = XCTestExpectation(description: "Failed with a bad status code")
        var failure: NetworkError?
        
        self.networkService?.fetchData(with: MockEnvironment.mockStatusCodeFailure.request)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    failure = error
                    expectation.fulfill()
                case .finished:
                    XCTFail()
                }
            }, receiveValue: { (_: FlickrWrapper) in
                XCTFail()
            })
            .store(in: &self.subs)
        
        wait(for: [expectation], timeout: 2)
        XCTAssertEqual(failure, NetworkError.badStatusCode(404))
    }
    
    func testNetworkFetchDecodeFail() {
        let expectation = XCTestExpectation(description: "Failed with a decode failure")
        var failure: NetworkError?
        
        self.networkService?.fetchData(with: MockEnvironment.mockDecodeFailure.request)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    failure = error
                    expectation.fulfill()
                case .finished:
                    XCTFail()
                }
            }, receiveValue: { (_: [FlickrWrapper]) in
                XCTFail()
            })
            .store(in: &self.subs)
        
        wait(for: [expectation], timeout: 2)
        
        XCTAssertEqual(failure, NetworkError.decodeError(DecodingError.typeMismatch(Array<Any>.self, DecodingError.Context(codingPath: [], debugDescription: "Expected to decode Array<Any> but found a dictionary instead."))))
    }
    
    func testNetworkFetchOtherFail() {
        let expectation = XCTestExpectation(description: "Failed with a general error")
        var failure: NetworkError?
        
        self.networkService?.fetchData(with: MockEnvironment.mockOther.request)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                    failure = error
                    expectation.fulfill()
                case .finished:
                    XCTFail()
                }
            }, receiveValue: { (_: FlickrWrapper) in
                XCTFail()
            })
            .store(in: &self.subs)
        
        wait(for: [expectation], timeout: 2)
        
        XCTAssertEqual(failure, NetworkError.other(NSError(domain: "General Error", code: 222)))
    }

}
