//
//  RoundedEdgeModifier.swift
//  SearchFlickrImages
//
//  Created by Rakesh on 7/12/24.
//

import SwiftUI

struct RoundedEdge: ViewModifier {
    let width: CGFloat
    let color: Color
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content.cornerRadius(cornerRadius - width)
            .padding(width)
            .background(color)
            .cornerRadius(cornerRadius)
    }
}
