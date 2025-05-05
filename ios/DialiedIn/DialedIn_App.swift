//
//  DialedIn_App.swift
//  Dialied In
//
//  Created by Kyle Satti on 5/3/25.
//
import SwiftUI

@main
struct DialedIn_App: App {
    @ObservedObject private var session = SessionManager.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ZStack {
                if session.isOnboarding {
                    NavigationStack {
                        WelcomeView()
                    }
                    .onOpenURL(perform: { url in
                        DeepLinkManager.shared.open(url)
                    })
                    .environment(\.onboardingCompletion) {
                        SessionManager.shared.isOnboarding = false
                    }
                } else {
                    Root()
                        .onOpenURL(perform: { url in
                            DeepLinkManager.shared.open(url)
                        })
                }
            }
            .animation(.easeInOut, value: session.isOnboarding)
        }
    }
}
