//
//  String+Extensions.swift
//  SearchImagesOnFlickrAPI
//
//  Created by Rakesh on 7/12/24.
//

import Foundation

extension String {
    func htmlAttributedString() -> NSMutableAttributedString? {
        guard let data = self.data(using: String.Encoding.utf16, allowLossyConversion: false) else { return nil }
        guard let html = try? NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) else { return nil }
        return html
    }
}

