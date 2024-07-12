//
//  MockEnvironmentEndPoints.swift
//  SearchImagesOnFlickrAPITests
//
//  Created by Rakesh on 7/12/24.
//

import Foundation
@testable import SearchImagesOnFlickrAPI

enum MockEnvironment {
    case success
    case mockStatusCodeFailure
    case mockDecodeFailure
    case mockOther
    
    var request: URLRequest? {
        
        var path = "https://"
        
        switch self {
        case .success:
            path.append("Success")
        case .mockStatusCodeFailure:
            path.append("StatusCodeFailure")
        case .mockDecodeFailure:
            path.append("DecodeFailure")
        case .mockOther:
            path.append("GeneralFailure")
        }
        
        guard let url = URL(string: path) else { return nil }
        return URLRequest(url: url)
    }
}

