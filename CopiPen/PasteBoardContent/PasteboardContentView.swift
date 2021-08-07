import SwiftUI

struct PasteboardContentView: View {
    let content: Content
    var body: some View {
        Group {
            switch content.contentType {
            case nil:
                EmptyView()
            case let .text(text):
                PasteboardContentTextComponent(text: text)
            case let .image(image):
                PasteboardContentImageComponent(image: image)
            case let .url(url):
                PasteboardContentURLComponent(url: url)
            }
        }
        .onTapGesture {
            if let contentType = content.contentType {
                let pasteboardType = contentType.pasteboardType
                switch contentType {
                case .text(let text):
                    UIPasteboard.general.setValue(text, forPasteboardType: pasteboardType)
                case .image(let image):
                    UIPasteboard.general.setValue(image, forPasteboardType: pasteboardType)
                case .url(let url):
                    UIPasteboard.general.setValue(url, forPasteboardType: pasteboardType)
                }
            }
        }
    }
}

