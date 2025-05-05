//
//  CreateCoffeeView.swift
//  Dialied In
//
//  Created by Kyle Satti on 5/4/25.
//

import SwiftUI

struct CreateCoffeeView: View {
    var body: some View {
        HStack {
            CodeScannerView(codeTypes: [.upce]) { result in
                switch result {
                case .success(let code):
                    print("Scanned: \(code)")
                case .failure(let error):
                    print("Scanning failed: \(error)")
                }
            }
        }
    }
}
