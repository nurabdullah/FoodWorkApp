
import SwiftUI

extension View {
    func textFieldStyle(isFocused: Bool) -> some View{
        self.textFieldStyle(PlainTextFieldStyle())
            .padding(10)
            .autocapitalization(.none)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(isFocused ? Color.orange : Color.gray.opacity(0.2), lineWidth: 2)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
            )
    }
}


