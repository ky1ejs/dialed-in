//
//  Welcome.swift
//  Dialied In
//
//  Created by Kyle Satti on 5/3/25.
//

import SwiftUI
import Apollo

struct WelcomeView: View {
    @State var presentOnboarding = false
    @State var pushEmail = false
    @State var annonymousSignUp: Apollo.Cancellable?
    @State var annonymousSignUpError: Error?

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Text("Dialed In")
                    .font(.cut_largeTitle)
                    .bold()
                Text("Find your favorite coffees and recipes")
                    .font(.cut_title1)
                    .bold()
                    .multilineTextAlignment(.center)
                    .foregroundStyle(UIColor.gray20.color)
                    .padding(.bottom, 24)
                PrimaryButton("Get Started") {
                    let impactMed = UIImpactFeedbackGenerator(style: .medium)
                    impactMed.impactOccurred()
                    presentOnboarding = true
                }
                .padding(.horizontal, 12)
                .sheet(isPresented: $presentOnboarding) {
                    VStack(spacing: 24) {
                        if let error = annonymousSignUpError {
                            Text("Error")
                            Text(error.localizedDescription)
                            PrimaryButton("Okay") {
                                annonymousSignUpError = nil
                            }
                        } else if let _ = annonymousSignUp {
                            ProgressView()
                        } else {
                            Text("Get Started")
                                .font(.cut_largeTitle)
                            Text("Create a free account.")
                                .multilineTextAlignment(.center)
                            VStack {
                                PrimaryButton("Continue with email") {
                                    pushEmail = true
                                    presentOnboarding = false
                                }
                                HStack {
                                    Button("") {

                                    }
                                    .buttonStyle(SecondaryButtonStyle())
                                    Button("G") {

                                    }
                                    .buttonStyle(SecondaryButtonStyle())
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 12)
                    .presentationDetents([.fraction(0.45)])
                    .presentationBackgroundInteraction(.disabled)
                }
            }
            .ignoresSafeArea()
            .navigationDestination(isPresented: $pushEmail) {
                EmailForm()
            }
            if presentOnboarding {
                VisualEffectView(effect: UIBlurEffect(style: .dark))
                    .ignoresSafeArea()
            }
        }
        .animation(.linear, value: presentOnboarding)
    }

    private func offset(_ i: Int) -> CGFloat {
        let offset: CGFloat = 24
        switch i {
        case 0: return offset
        case 2: return -offset
        default: return 0
        }
    }
}

#Preview {
    NavigationStack {
        WelcomeView()
    }
}
