//
//  UrlConstant.swift
//  CoinTred
//
//  Created by MAC on 12/03/22.
//

struct UrlConstant {
    static let server = "https://api.coingecko.com/api/v3/"
    static let market = server + "coins/markets?vs_currency="
    static let market_chart = server + "coins/{id}/market_chart"
    static let market_detail = server + "coins/{id}"

}
