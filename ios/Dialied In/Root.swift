//
//  Root.swift
//  Dialied In
//
//  Created by Kyle Satti on 5/3/25.
//
import SwiftUI

struct Root: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        TabView {
            ContentView()
        }
        .environment(\.theme, Theme.for(colorScheme))
    }
}

#Preview {
    Root()
}
