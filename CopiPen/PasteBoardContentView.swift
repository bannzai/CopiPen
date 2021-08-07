import SwiftUI

struct PasteBoardContentView: View {
    let content: Content
    var body: some View {
        switch content.contentType {
        case nil:
            EmptyView()
        case let .text(text):
            Text(text)
        case let .image(image):
            Image(uiImage: image)
        case let .url(url):
            Text(url.absoluteString)
        }
    }
}

