//
//  RateFluctuationModel.swift
//  ExchangeRates
//
//  Created by Davi Martinelli de Lira on 10/11/23.
//

import Foundation

struct RateFluctuationModel: Identifiable {
    let id = UUID()
    var symbol: String
    var change: Double
    var changePct: Double
    var endRate: Double
}
