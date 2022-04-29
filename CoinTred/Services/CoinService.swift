//
//  Service.swift
//  CoinTred
//
//  Created by MAC on 12/03/22.
//

import Foundation

public protocol MarketCoinProtocol: AnyObject {
    func getCoinMarket (currency: String, page: Int, limit: Int, order: String, onSuccess: (([CoinMarketResponse]) -> Void)?, onError: ((String) -> Void)?)
    func getMarketDetail (id: String,onSuccess: ((MarketDetail) -> Void)?, onError: ((String) -> Void)?)
}

class CoinService : MarketCoinProtocol {
    func getCoinMarket(currency: String, page: Int, limit : Int, order: String, onSuccess: (([CoinMarketResponse]) -> Void)?, onError: ((String) -> Void)? ) {
        let url = UrlConstant.market + currency + "&per_page=" + "\(limit)" + "&order=" + order + "&page=" + "\(page)"
        Connection.shared.connect(url: url, params: nil, model: [CoinMarketResponse].self, completion: { result in
            switch result {
            case .success(let response) :
                onSuccess?(response)
            case .failure(let error) :
                onError?(error.localizedDescription)
            }
        })
    }

    func getMarketDetail(id: String, onSuccess: ((MarketDetail) -> Void)?, onError: ((String) -> Void)?) {
        let url = UrlConstant.market_detail.replacingOccurrences(of: "{id}", with: String(id))
        Connection.shared.connect(url: url, params: nil, model: MarketDetail.self, completion: { result in
            switch result {
            case .success(let response) :
                onSuccess?(response)
            case .failure(let error) :
                onError?(error.localizedDescription)
            }
        })
    }
}
