import SwiftUI

struct ToastModifier<Toast: View>: ViewModifier {
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
    func toast<Toast: View>(isPresented: Binding<Bool>, @ViewBuilder toast: @escaping () -> Toast) -> some View {
        modifier(ToastModifier(isPresented: isPresented, toast: toast))
    }
}
