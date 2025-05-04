//
//  Mocks.swift
//  Dialied In
//
//  Created by Kyle Satti on 5/3/25.
//

import Foundation
import ApolloAPI

struct Mocks {
    static func parse<T: RootSelectionSet>(_ json: String) -> T {
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: json.data(using: .utf8)!) as! [String: AnyHashable]
                return try T(data: jsonObject)
            } catch {
                print(error.localizedDescription)
                fatalError(error.localizedDescription)
            }
        }
    
    static func coffee() -> Coffee {
            let json = """
                {
                    "__typename": "Coffee",
                    "id": "\(UUID().uuidString)",
                    "name": "Honey",
                    "roastDate": "2025-01-01T00:00:00.000Z",
                    "roasterName": "Devocion",
                    "weight": null,
                    "weightUnit": "GRAMS"
                }
            """
            return parse(json)
        }
}
