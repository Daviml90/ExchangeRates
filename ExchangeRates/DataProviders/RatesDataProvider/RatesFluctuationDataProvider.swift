//
//  RatesFluctuationDataProvider.swift
//  ExchangeRates
//
//  Created by Davi Martinelli de Lira on 10/6/23.
//

import Foundation
import Combine

protocol RatesFluctuationDataProviderProtocol {
    func fetchFluctuation(by base: String, from symbols: [String], startDate: String, endDate: String) -> AnyPublisher<[RateFluctuationModel], Error>
}

class RatesFluctuationDataProvider: RatesFluctuationDataProviderProtocol {
    
    private let ratesStore: RatesStore
    
    init(ratesStore: RatesStore = RatesStore()) {
        self.ratesStore = ratesStore
    }
    
    func fetchFluctuation(by base: String, from symbols: [String], startDate: String, endDate: String) -> AnyPublisher<[RateFluctuationModel], Error> {
        return Future { promise in
            self.ratesStore.fetchFluctuation(by: base, from: symbols, startDate: startDate, endDate: endDate) { result, error in
                if let error {
                    return promise(.failure(error))
                }
                
                guard let rates = result?.rates else {
                    return //promise(.failure(error)) TODO: - Passar esse erro para a ViewModel
                }
                
                let ratesFluctuations = rates.map({ (symbol, fluctuation) -> RateFluctuationModel in
                    return RateFluctuationModel(symbol: symbol, change: fluctuation.change, changePct: fluctuation.changePct, endRate: fluctuation.endRate)
                })
                return promise(.success(ratesFluctuations))
            }
        }.eraseToAnyPublisher()
    
    }
}
