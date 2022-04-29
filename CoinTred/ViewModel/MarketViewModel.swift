//
//  MarketViewModel.swift
//  CoinTred
//
//  Created by MAC on 14/03/22.
//

public final class MarketViewModel {

    var service    : MarketCoinProtocol?
    var totalAmount : Double = 0.0

    init(service: MarketCoinProtocol) {
        self.service = service
    }

    var didFinishLoadDataMarket : ((_ response : [CoinMarketResponse]) -> Void)?
    var didFinishLoadMarketDetail : ((_ response : MarketDetail) -> Void)?

    var didFailRequest: ((_ msg: String) -> Void)?

    func getCoinMarket(country : String, page : Int, limit : Int, order : String) {
        service?.getCoinMarket(currency: country, page: page, limit : limit, order: order, onSuccess: { [weak self](data) in
            self?.didFinishLoadDataMarket?(data)
        }, onError: { [weak self] errorMessage in
            if page == 1 {
                self?.didFailRequest?(errorMessage)
            } else {
                self?.didFinishLoadDataMarket?([])
            }
        })
    }
    
    func getMarketDetail(id : String) {
        service?.getMarketDetail(id: id, onSuccess: { (data) in
            self.didFinishLoadMarketDetail?(data)
        }, onError: { [weak self] errorMessage in
            self?.didFailRequest?(errorMessage)
        })
    }
}
