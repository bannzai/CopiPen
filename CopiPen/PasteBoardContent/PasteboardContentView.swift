import SwiftUI

struct PasteboardContentView: View {
    let content: CopiedContent
    let onPaste: (CopiedContent.Item) -> Void

    var body: some View {
        Button(action: action, label: {
            switch content.preferredContentItem?.kind {
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
        if let item = content.preferredContentItem {
            UIPasteboard.general.addItems(item.allItems)
            onPaste(item)
        }
    }
}

