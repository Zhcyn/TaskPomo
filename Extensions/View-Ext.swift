import SwiftUI
@available(iOS 13.0, *)
extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}
