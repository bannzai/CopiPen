import SwiftUI

struct PasteboardContentTextComponent: View {
    let text: String

    var body: some View {
        HStack {
            Image(systemName: "doc.text")
            Spacer().frame(width: 12)
            Text(text)
        }
    }
}
