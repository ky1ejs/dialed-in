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
    
    var body: some View {
        List(coffees, id: \.id) { coffee in
            Text(coffee.name)
        }
        .toolbar {
            Button("Add") {
                
            }
        }
        .toolbarVisibility(.visible, for: .navigationBar)
        .task {
            Network.shared.client.fetch(query: ListCoffeeBagsQuery()) { result in
                switch result {
                case .success(let val):
                    if let bags = val.data?.coffeeBags {
                        coffees = bags.map { $0.fragments.coffeeFragment}
                    }
                case .failure(let error):
                    print("Error fetching coffee bags: \(error)")
                }
            }
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
