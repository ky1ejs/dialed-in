//
//  CoffeeList.swift
//  Dialied In
//
//  Created by Kyle Satti on 5/3/25.
//

import SwiftUI
import DialedInGraphQLAPI

struct CoffeeList: View {
    @State var coffees: [Coffee] = []
    @State var showAddCoffeeSheet: Bool = false
    
    var body: some View {
        List(coffees, id: \.id) { coffee in
            Text(coffee.name)
        }
        .toolbar {
            Button("Add") {
                showAddCoffeeSheet = true
            }
        }
        .toolbarVisibility(.visible, for: .navigationBar)
        .task {
            Network.shared.client.fetch(query: ListCoffeeBagsQuery()) { result in
                switch result.parseGraphQL() {
                case .success(let data):
                    coffees = data.coffeeBags.map { $0.fragments.coffeeFragment}
                case .failure(let error):
                    print("Error parsing GraphQL: \(error)")
                    return
                }
            }
        }
        .sheet(isPresented: $showAddCoffeeSheet) {
            CreateCoffeeView()
        }
    }
}

#Preview {
    NavigationStack {
        CoffeeList(coffees: [
            Mocks.coffee(),
            Mocks.coffee(),
            Mocks.coffee()
        ])
    }
}
