//
//  ContentView.swift
//  Dialied In
//
//  Created by Kyle Satti on 5/2/25.
//

import SwiftUI
import Apollo
import DialedInGraphQLAPI


struct ContentView: View {
    @State var coffee: CoffeeFragment?
    
    func thing() {
        Network.shared.apollo.fetch(query: LastUsedCoffeeQuery()) { result in
            switch result {
                case .success(let graphQLResult):
                coffee = graphQLResult.data?.lastUsedCoffee?.fragments.coffeeFragment
            case .failure(let error):
                print(error)
            }
        }
    }
    var body: some View {
        VStack {
            Text("Brew")
                .font(.title)
            HStack {
                VStack(alignment: .leading) {
                    Text("Coffee")
                        .font(.headline)
                    if let coffee {
                        Text(coffee.name)
                    } else {
                        Text("Select a coffee")
                    }
                }
                Spacer()
            }
        }
        .task {
            thing()
        }
        .border(.red)
        .padding()
    }
}

#Preview {
    ContentView()
}
