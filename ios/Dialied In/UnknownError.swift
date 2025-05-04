//
//  UnknownError.swift
//  Dialied In
//
//  Created by Kyle Satti on 5/3/25.
//

import Foundation

struct UnknownError: LocalizedError {
    var errorDescription: String? { "Unknown error -- data missing" }
}
