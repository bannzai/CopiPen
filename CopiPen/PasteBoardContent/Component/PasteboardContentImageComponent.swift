import UIKit
import SwiftUI

struct PasteboardContentImageComponent: View {
    let image: UIImage

    var body: some View {
        HStack {
            Image(systemName: "photo")
            Spacer().frame(width: 16)
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
}
