import SwiftUI

struct PasteboardContentURLComponent: View {
    let url: URL

    var body: some View {
        Text(url.absoluteString)
    }
}

