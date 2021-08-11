import SwiftUI

struct AlertError: LocalizedError, Identifiable {
    var id: Kind { kind }
    let kind: Kind
    let error: EquatableError

    enum Kind: Int, Identifiable {
        case add
        case delete
        
        var id: Kind { self }
        var title: String {
            switch self {
            case .add:
                return "貼り付けに失敗しました"
            case .delete:
                return "削除に失敗しました"
            }
        }
    }
}

struct ErrorAlertModifier: ViewModifier {
    @Binding var alertError: AlertError?

    func body(content: Content) -> some View {
        content.alert(item: _alertError) { alertError in
            Alert(
                title: Text(alertError.kind.title),
                message: Text(alertError.errorDescription ?? "エラーが発生しました"),
                primaryButton: .default(Text("OK")),
                secondaryButton: .cancel()
            )
        }
    }
}

extension View {
    func errorAlert(error: Binding<AlertError?>) -> some View {
        modifier(ErrorAlertModifier(alertError: error))
    }
}
