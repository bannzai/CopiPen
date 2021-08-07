import SwiftUI

struct PasteBoardContentView: View {
    let content: Content
    var body: some View {
        switch content.contentType {
        case nil:
            EmptyView()
        case let .text(text):
            PasteBoardContentTextComponent(text: text)
        case let .image(image):
            PastBoardContentImageComponent(image: image)
        case let .url(url):
            PasteBoardContentURLComponent(url: url)
        }
    }
}

