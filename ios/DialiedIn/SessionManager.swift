//
//  SessionManager.swift
//  Dialied In
//
//  Created by Kyle Satti on 5/3/25.


import Foundation
import KeychainAccess
import UIKit
import Apollo
import DialedInGraphQLAPI

public class SessionManager: ObservableObject {
    @Published private(set) var sessionId: String? = nil
    @Published var isOnboarding: Bool

    static let shared = try! SessionManager()

    private static let SESSION_ID_KEY = "session"
    private let keychain: Keychain
    private let client = Network.shared.client

    init() throws {
        let keychain = Keychain(
            service: "coffee.dialedin",
            accessGroup: "X2TBSUCASC.coffee.dialedin"
        ).accessibility(.afterFirstUnlock)
        let sessionId = try keychain.getString(SessionManager.SESSION_ID_KEY)

        self.keychain = keychain
        self.sessionId = sessionId
        self.isOnboarding = sessionId == nil
    }

    enum SignInError: Error {
        case error(Error)
        case unknown
    }

    func setAnnonymousSessionToken(_ token: String) throws {
        try storeSessionId(token)
        sessionId = token
        isOnboarding = false
    }

    func userLoggedIn(user: User, sessionId: String) throws {
        try self.storeSessionId(sessionId)
        self.sessionId = sessionId

        Network.shared.client.store.withinReadWriteTransaction { txn in
            try txn.update(MeLocalCacheMutation()) { set in
                set.me.email = user.email
                set.me.name = user.name
                set.me.username = user.username
                set.me.bio = user.bio
            }
        }
    }

    private func readSessionId() throws -> String? {
        return try keychain.getString(type(of: self).SESSION_ID_KEY)
    }

    private func storeSessionId(_ id: String) throws {
        try keychain.set(id, key: type(of: self).SESSION_ID_KEY)
    }

    private func logOut(remotely: Bool) throws {
        if remotely {
            Network.shared.client.perform(mutation: LogOutMutation())
        }
        sessionId = nil
        isOnboarding = true
        try keychain.removeAll()
        Network.shared.client.store.clearCache()
    }

    func logOut() throws {
        try logOut(remotely: true)
    }

    func accountDeleted() throws {
        try logOut(remotely: false)
    }
}
