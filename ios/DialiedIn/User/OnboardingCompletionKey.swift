//
//  OnboardingCompletionKey.swift
//  Dialied In
//
//  Created by Kyle Satti on 5/3/25.
//

import SwiftUI

private struct OnboardingCompletionKey: EnvironmentKey {
    static var defaultValue: () -> Void = {}
}

extension EnvironmentValues {
  var onboardingCompletion: () -> Void {
    get { self[OnboardingCompletionKey.self] }
    set { self[OnboardingCompletionKey.self] = newValue }
  }
}
