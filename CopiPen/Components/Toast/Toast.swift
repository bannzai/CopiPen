import SwiftUI

struct Toast: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.caption)
            .foregroundColor(.white)
            .frame(maxWidth: 240)
            .padding(.vertical, 16)
            .background(Color(.systemGray3))
            .cornerRadius(24)
    }
}
