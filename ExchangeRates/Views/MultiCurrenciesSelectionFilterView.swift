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
    
    var delegate: MultiCurrenciesSelectionFilterViewDelegate? // TODO - para reatividade
    
//    var searchResults: [CurrencySymbolModel] {
//        if searchText.isEmpty {
//            return viewModel.currencySymbols
//        } else {
//            return viewModel.currencySymbols.filter {
//                $0.symbol.contains(searchText.uppercased()) || $0.fullName.uppercased().contains(searchText.uppercased())
//            }
//        }
//    }
    
    var body: some View {
        NavigationView {
            if case .loading = viewModel.currentState {
                ProgressView()
                    .scaleEffect(2.2, anchor: .center)
            } else if case .success = viewModel.currentState {
                listCurrenciesView
            } else if case .failure = viewModel.currentState {
                errorView
            }
            
        }
        .onAppear {
            viewModel.doFetchCurrencySymbols()
        }
    }
    
    private var listCurrenciesView: some View {
        List(viewModel.searchResults, id: \.symbol) { item in
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
        .searchable(text: $searchText, prompt: "Buscar moeda base")
        .onChange(of: searchText) { searchText in
            if searchText.isEmpty {
                viewModel.searchResults = viewModel.currencySymbols
            } else {
                viewModel.searchResults = viewModel.currencySymbols.filter {
                    $0.symbol.contains(searchText.uppercased()) ||
                    $0.fullName.contains(searchText.uppercased())
                }
            }
        }        .navigationTitle("Filtrar Moedas")
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
    
    private var errorView: some View {
        VStack(alignment: .center) {
           Spacer()
            
            Image(systemName: "wifi.exclamationmark")
                .resizable()
                .frame(width: 60, height: 44)
                .padding(.bottom, 4)
            
            Text("Ocorreu um erro na busca dos simbolos das moedas!")
                .font(.headline.bold())
                .multilineTextAlignment(.center)
            
            Button {
                viewModel.doFetchCurrencySymbols()
            } label: {
                Text("Tentar novamente?")
            }
            .padding(.top, 4)
            
            Spacer()
        }
        .padding()
        
    }
}

#Preview {
    MultiCurrenciesSelectionFilterView()
}
