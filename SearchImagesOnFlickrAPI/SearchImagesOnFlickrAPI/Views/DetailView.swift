//
//  DetailView.swift
//  SearchImagesOnFlickrAPI
//
//  Created by Rakesh on 7/12/24.
//

import SwiftUI

struct DetailView: View {
    let item: FlickrImage
    
    init(item: FlickrImage) {
        self.item = item
    }
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(alignment: .center, spacing: 8, content: {
                AsyncImage(url: URL(string: item.media.m)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .frame(maxWidth: .infinity, maxHeight: 200)
                            .aspectRatio(contentMode: .fill)
                            .modifier(RoundedEdge(width: 3, color: Color(uiColor: .label), cornerRadius: 5))
                    case .failure:
                        Image(systemName: "questionmark.app.fill")
                    @unknown default:
                        Image(systemName: "questionmark.app.fill")
                    }
                }
                Text(item.title)
                Text(htmlString(from: item.description))
                Text(item.author)
                Text(formattedDate(from: item.published))
                Spacer()
            })
            .padding()
        }
    }
    
    func htmlString(from htmlString: String) -> AttributedString {
        guard let attrString = htmlString.htmlAttributedString() else { return AttributedString() }
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        attrString.addAttributes([.paragraphStyle: style], range: NSRange(location: 0, length: attrString.length))
        return AttributedString(attrString)
    }
    
    func formattedDate(from dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = formatter.date(from: dateString) {
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }
        return dateString
    }
}

#Preview {
    DetailView(item: FlickrImage(title: "", link: "", media: Media(m: ""), dateTaken: "", description: "", published: "", author: "", authorId: "", tags: ""))
}
