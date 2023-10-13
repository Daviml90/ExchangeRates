//
//  RateHistoricalModel.swift
//  ExchangeRates
//
//  Created by Davi Martinelli de Lira on 10/11/23.
//

import Foundation

struct RateHistoricalModel: Identifiable {
    let id = UUID()
    var symbol: String
    var period: Date
    var endRate: Double
}
