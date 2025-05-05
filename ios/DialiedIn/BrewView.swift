//
//  ContentView.swift
//  Dialied In
//
//  Created by Kyle Satti on 5/2/25.
//

import SwiftUI
import Apollo
import DialedInGraphQLAPI


struct BrewView: View {
    @State var coffee: CoffeeFragment?
    @State var pushCoffeePicker: Bool = false
    
    func thing() {
        Network.shared.client.fetch(query: LastUsedCoffeeQuery()) { result in
            switch result {
                case .success(let graphQLResult):
                coffee = graphQLResult.data?.lastUsedCoffee?.fragments.coffeeFragment
            case .failure(let error):
                print(error)
            }
        }
    }
    var body: some View {
        NavigationStack {
            VStack {
                Text("Brew")
                    .font(.title)
                HStack {
                    Button {
                        pushCoffeePicker = true
                    } label: {
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
            }
            .task {
                thing()
            }
            .border(.red)
            .padding()
            .navigationBarTitle("Brew")
            .navigationDestination(isPresented: $pushCoffeePicker) {
                CoffeeList()
            }
        }
    }
}

#Preview {
    BrewView()
}
