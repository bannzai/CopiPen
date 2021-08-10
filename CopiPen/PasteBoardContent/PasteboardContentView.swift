import SwiftUI

struct PasteboardContentView: View {
    let content: Content
    let didEndPaste: (Content.ContentType) -> Void

    var body: some View {
        Button(action: action, label: {
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
        })
    }
    
    private func action() {
        if let contentType = content.contentType {
            defer {
                didEndPaste(contentType)
            }

            let pasteboardType = contentType.pasteboardType
            switch contentType {
            case .text(let text):
                UIPasteboard.general.setValue(text, forPasteboardType: pasteboardType)
            case .image(let image):
                UIPasteboard.general.setValue(image.jpegData(compressionQuality: 1)!, forPasteboardType: pasteboardType)
            case .url(let url):
                UIPasteboard.general.setValue(url, forPasteboardType: pasteboardType)
            }
        }
    }
}

