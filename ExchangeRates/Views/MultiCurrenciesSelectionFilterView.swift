//
//  CurrencySelectionFilterView.swift
//  ExchangeRates
//
//  Created by Davi Martinelli de Lira on 10/11/23.
//

import SwiftUI

protocol MultiCurrenciesSelectionFilterViewDelegate {
    func didSelected(_ currencies: [String])
}

struct MultiCurrenciesSelectionFilterView: View {
    
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel = ViewModel()
    @State private var selections: [String] = []
    @State private var searchText = ""
    
    var delegate: MultiCurrenciesSelectionFilterViewDelegate?
    
    var searchResults: [CurrencySymbolModel] {
        if searchText.isEmpty {
            return viewModel.currencySymbols
        } else {
            return viewModel.currencySymbols.filter {
                $0.symbol.contains(searchText.uppercased()) || $0.fullName.uppercased().contains(searchText.uppercased())
            }
        }
    }
    
    var body: some View {
        NavigationView {
            listCurrenciesView
        }
        .onAppear {
            viewModel.doFetchCurrencySymbols()
        }
    }
    
    private var listCurrenciesView: some View {
        List(searchResults, id: \.symbol) { item in
            Button {
                if selections.contains(item.symbol) {
                    selections.removeAll { $0 == item.symbol }
                } else {
                    selections.append(item.symbol)
                }
            } label: {
                HStack {
                    HStack {
                        Text(item.symbol)
                            .font(.system(size: 14, weight: .bold))
                        Text("-")
                            .font(.system(size: 14, weight: .semibold))
                        Text(item.fullName)
                            .font(.system(size: 14, weight: .semibold))
                        Spacer()
                    }
                    Image(systemName: "checkmark")
                        .opacity(selections.contains(item.symbol) ? 1.0 : 0.0)
                    Spacer()
                }
            }
            .foregroundColor(.primary)
            
        }
        .searchable(text: $searchText)
        .navigationTitle("Filtrar Moedas")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button {
                delegate?.didSelected(selections)
                dismiss()
            } label: {
                Text(selections.isEmpty ? "Cancelar" : "OK")
                    .fontWeight(.bold)
            }
        }
    }
    
}

#Preview {
    MultiCurrenciesSelectionFilterView()
}
