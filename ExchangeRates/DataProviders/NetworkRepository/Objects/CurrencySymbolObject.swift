//
//  CurrencySymbolObject.swift
//  ExchangeRates
//
//  Created by Davi Martinelli de Lira on 10/4/23.
//

import Foundation

struct CurrencySymbolObject: Codable {
    var base: String?
    var success: Bool = false
    var symbols: SymbolObject?
}


typealias SymbolObject = [String: String]
