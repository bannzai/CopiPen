import UIKit
import SwiftUI

struct PasteboardContentImageComponent: View {
    let image: UIImage

    var body: some View {
        Image(uiImage: image)
            .frame(maxHeight: 200)
            .scaledToFill()
            .clipped()
    }
}
