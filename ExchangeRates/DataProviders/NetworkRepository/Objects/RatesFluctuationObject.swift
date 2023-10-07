//
//  RatesFluctuationObject.swift
//  ExchangeRates
//
//  Created by Davi Martinelli de Lira on 10/4/23.
//

import Foundation

typealias RatesFluctuationObject = [String: FluctuationObject]

struct FluctuationObject: Codable {
    let endRate, change, changePct: Double

    enum CodingKeys: String, CodingKey {
        case endRate = "end_rate"
        case change
        case changePct = "change_pct"
    }
}
