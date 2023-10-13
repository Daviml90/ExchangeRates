//
//  CurrencySymbolModel.swift
//  ExchangeRates
//
//  Created by Davi Martinelli de Lira on 10/11/23.
//

import Foundation

struct CurrencySymbolModel: Identifiable {
    let id = UUID()
    var symbol: String
    var fullName: String
}
