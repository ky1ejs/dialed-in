//
//  Network.swift
//  Dialied In
//
//  Created by Kyle Satti on 5/2/25.
//


import Foundation
import Apollo

class Network {
  static let shared = Network()

  private(set) lazy var apollo = ApolloClient(url: URL(string: "http://localhost:4000/graphql")!)
}
