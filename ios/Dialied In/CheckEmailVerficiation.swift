//
//  CheckEmailVerficiation.swift
//  Dialied In
//
//  Created by Kyle Satti on 5/3/25.
//

import SwiftUI
import Apollo
import DialedInGraphQLAPI

struct CheckEmailVerification: View {
    let email: String
    @StateObject private var deepLinkObserver = EmailVerifyDeepLinkHandler()
    private static let defaultWait = 30
    @State var timeRemaining = CheckEmailVerification.defaultWait
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var inFlightRequest: Apollo.Cancellable?
    @State var error: Error?
    @State var code = ""
    @State var attemptId: String
    @State var pushNextStep = false
    @Environment(\.onboardingCompletion) var onboardingCompletion

    var body: some View {
        VStack(spacing: 32) {
            VStack {
                Image("email_icon")
                    .overlay {
                        VStack {
                            HStack {
                                Spacer()
                                Circle()
                                    .frame(width: 18, height: 18)
                            }
                            Spacer()
                        }
                    }
                Text("Check your email")
                    .font(.cut_title1)
                    .bold()
                Text("Open the link in the email we just sent you. Don't forget to check the spam folder in case it doesn't turn up.")
                    .multilineTextAlignment(.center)
            }
            OtpCodeTextField(text: $code, digitCount: 4) {
                authenticate()
            }
            PrimaryButton("Resend\(timeRemaining > 0 ? " (in \(timeRemaining) seconds)" : "")", isLoading: inFlightRequest != nil) {
                inFlightRequest = Network.shared.apollo.perform(mutation: InitiateAuthMutation(email: email)) { result in
                    switch result.parseGraphQL() {
                    case .success(let data):
                        attemptId = data.initiateAuth
                        timeRemaining = type(of: self).defaultWait
                    case .failure(let error):
                        self.error = error
                    }
                    inFlightRequest = nil
                }
            }
            .disabled(timeRemaining != 0 || inFlightRequest != nil)
        }
        .padding(.horizontal, 16)
        .navigationDestination(isPresented: $pushNextStep) {
            CompleteAccountForm(
                authId: attemptId,
                code: code
            )
        }
        .onOpenURL(perform: { url in
            _ = deepLinkObserver.open(url)
        })
        .onReceive(timer, perform: { _ in
            timeRemaining = max(timeRemaining - 1, 0)
        })
        .onReceive(deepLinkObserver.$deepLinkCode, perform: { code in
            guard let code = code else { return }
            self.code = code

        })
        .errorAlert(error: $error)
    }

    private func authenticate() {
        guard inFlightRequest == nil else { return }
        let deviceName = UIDevice.current.name
        let mutation = ValidateAuthMutation(authId: attemptId, deviceName: deviceName, code: code)
        inFlightRequest = Network.shared.apollo.perform(mutation: mutation) { result in
            switch result.parseGraphQL() {
            case .success(let data):
                let r = data.validateAuth
                if let authResult = r.asAuthResponse {
                    let user = authResult.user.fragments.userFragment
                    let sessionId = authResult.device.sessionId
                    try! SessionManager.shared.userLoggedIn(user: user, sessionId: sessionId)
                    onboardingCompletion()
                } else {
                    pushNextStep = true
                }
            case .failure(let error):
                self.error = error
                code = ""
            }
            inFlightRequest = nil
        }
    }
}

class EmailVerifyDeepLinkHandler: DeepLinkHandler, ObservableObject {
    @Published var deepLinkCode: String?
    var id: String = "EmailVerifyDeepLinkHandler"
    let regexes = [
        /.*cut\.watch\/verify-email.*/,
        /.*cut:\/\/verify-email.*/
    ]

    init() {
        DeepLinkManager.shared.add(self)
    }

    deinit {
        DeepLinkManager.shared.remove(self)
    }

    func open(_ url: URL) -> Bool {
        let comps = URLComponents(url: url, resolvingAgainstBaseURL: false)
        guard let queryItems = comps?.queryItems else { return false }

        let maybeToken = {
            for item in queryItems {
                if item.name == "code" {
                    return item.value
                }
            }
            return nil
        }()

        guard let token = maybeToken else { return false }
        deepLinkCode = token
        return true
    }
}

#Preview {
    CheckEmailVerification(
        email: "test@test.com",
        attemptId: ""
    )
}
