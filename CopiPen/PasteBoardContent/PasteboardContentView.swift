import SwiftUI

struct PasteboardContentView: View {
    let content: Content
    var body: some View {
        switch content.contentType {
        case nil:
            EmptyView()
        case let .text(text):
            PasteboardContentTextComponent(text: text)
        case let .image(image):
            PastBoardContentImageComponent(image: image)
        case let .url(url):
            PasteboardContentURLComponent(url: url)
        }
    }
}

