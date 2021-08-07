import SwiftUI

struct PasteBoardContentURLComponent: View {
    let url: URL

    var body: some View {
        Text(url.absoluteString)
    }
}

