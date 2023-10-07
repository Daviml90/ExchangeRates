//
//  RatesApi.swift
//  ExchangeRates
//
//  Created by Davi Martinelli de Lira on 10/4/23.
//

import Foundation

enum HttpMethod: String {
    case get = "GET"
}

struct RatesApi {
    static let baseUrl = "https://api.apilayer.com/exchangerates_data"
    static let apiKey = "aluSBviM8yevhFN2G6br3GyHrnClYydu"
    static let fluctuation = "/fluctuation"
    static let symbols = "/symbols"
    static let timeseries = "/timeseries"
}
