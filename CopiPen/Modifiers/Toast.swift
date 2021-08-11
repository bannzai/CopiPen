import SwiftUI

struct ToastModifier<Toast: View>: ViewModifier {
    let duration: Double
    @Binding var isPresented: Bool
    @ViewBuilder let toast: () -> Toast

    func body(content: Content) -> some View {
        ZStack {
            content

            if isPresented {
                toast()
            }
        }
    }
}

extension View {
    func toast<Toast: View>(duration: TimeInterval = 1.5, isPresented: Binding<Bool>, @ViewBuilder toast: @escaping () -> Toast) -> some View {
        modifier(ToastModifier(duration: duration, isPresented: isPresented, toast: toast))
    }
}
