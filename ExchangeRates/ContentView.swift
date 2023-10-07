//
//  ContentView.swift
//  ExchangeRates
//
//  Created by Davi Martinelli de Lira on 10/3/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Button {
                doFetchData()
            } label: {
                Image(systemName: "network")
            }
        }
        .padding()
    }
    
    private func doFetchData() {
        let rateSymbolDataProvider = CurrencySymbolsDataProvider()
        rateSymbolDataProvider.delegate = self
        rateSymbolDataProvider.fetchSymbols()
    }
}

extension ContentView: CurrencySymbolsDataProviderDelegate {
    func success(model: CurrencySymbolObject) {
        print("RateSymbolDataProviderDelegate: \(model)\n\n")
    }
}

#Preview {
    ContentView()
}
