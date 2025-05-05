//
//  SecondaryButton.swift
//  Dialied In
//
//  Created by Kyle Satti on 5/3/25.
//

import SwiftUI

struct SecondaryButton: View {
    @Environment(\.theme) private var theme
    let text: String
    let action: () -> Void

    init(_ text: String, action: @escaping () -> Void) {
        self.text = text
        self.action = action
    }

    var body: some View {
        Button(action: action, label: {
            Text(text)
                .foregroundStyle(theme.primaryButtonBackground.color)
        })
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
    }
}

#Preview {
    SecondaryButton("Test") {

    }
}
