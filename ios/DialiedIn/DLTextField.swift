//
//  DLTextField.swift
//  Dialied In
//
//  Created by Kyle Satti on 5/3/25.
//

import SwiftUI

struct DLTextField<T>: View where T: View {
    @Environment(\.theme) var theme
    @Binding var text: String
    let label: String?
    let placeholder: String
    let isSecure: Bool
    let accessory: (() -> T)?

    init(
        text: Binding<String>,
        label: String? = nil,
        placeholder: String,
        isSecure: Bool = false,
        accessory: (() -> T)? = nil
    ) {
        _text = text
        self.label = label
        self.placeholder = placeholder
        self.isSecure = isSecure
        self.accessory = accessory
    }

    var body: some View {
        VStack(alignment: .leading) {
            if let label = label {
                Text(label).font(.cut_footnote)
            }
            HStack {
                if isSecure {
                    SecureField(text: $text) { placeholderText }
                } else {
                    TextField(text: $text) { placeholderText }
                }
                accessory?()
            }
        }
        .textFieldStyle(DLTextFieldStyle())
    }

    private var placeholderText: some View {
        Text(placeholder)
            .foregroundStyle(theme.textFieldPlaceholderColor.color)
    }
}

extension DLTextField where T == EmptyView {
    init(
        text: Binding<String>,
        label: String? = nil,
        placeholder: String,
        isSecure: Bool = false
    ) {
        _text = text
        self.label = label
        self.placeholder = placeholder
        accessory = nil
        self.isSecure = isSecure
    }
}

struct DLTextFieldStyle: TextFieldStyle {
    @Environment(\.theme) var theme

    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 10)
            .padding(.vertical, 12)
            .background(theme.textFieldBackground.color)
            .foregroundColor(theme.text.color)
            .font(.system(size: 20))
            .fontDesign(.rounded)
            .mask {
                RoundedRectangle(cornerRadius: 8)
            }
    }
}

#Preview {
    CompleteAccountForm(authId: "", code: "")
}
