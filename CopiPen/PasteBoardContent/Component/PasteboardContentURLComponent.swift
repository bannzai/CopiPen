import SwiftUI

struct PasteboardContentURLComponent: View {
    let url: URL

    var body: some View {
        HStack {
            Image(systemName: "link")
            Spacer().frame(width: 16)
            Text(url.absoluteString)
        }
    }
}

