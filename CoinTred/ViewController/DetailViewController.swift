//
//  DetailViewController.swift
//  CoinTred
//
//  Created by MAC on 26/03/22.
//

import UIKit
import Toaster

class DetailViewController: BaseViewController {
    
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSymbol: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblMarketCapValue: UILabel!
    @IBOutlet weak var lblMarketRankValue: UILabel!
    @IBOutlet weak var lblLowPrice: UILabel!
    @IBOutlet weak var lblHighPrice: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblPricePrecentage: UILabel!
    
    var data : CoinMarketResponse?
    var days : String = "1"
    var coinId : String = ""
    var currency : String = "usd"
    var priceChart : [[Double]] = []
    var change24h : Double = 0
    var change7d : Double = 0
    var change30d : Double = 0
    var change1y : Double = 0
 
    private lazy var viewModel: MarketViewModel = {
        let viewModel = MarketViewModel(service: CoinService())
        viewModel.didFinishLoadMarketDetail = self.onFinishLoadMarketDetail
        viewModel.didFailRequest = self.onFailRequest
        return viewModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        guard let dt = data else {return}
        navigationItem.title = dt.name
        coinId = dt.name?.lowercased().replacingOccurrences(of: " ", with: "") ?? ""
        lblName.text = dt.name
        lblSymbol.text = dt.symbol?.uppercased()
        lblMarketCapValue.text = dt.market_cap?.convertToCurrency()
        lblMarketRankValue.text = "\(dt.market_cap_rank ?? 0)"
        lblLowPrice.text = dt.low_24h?.convertToCurrency()
        lblHighPrice.text = dt.high_24h?.convertToCurrency()
        
        let currentPrice = data?.current_price ?? 0
        if currentPrice < 1 {
            lblPrice.text = "$\(data?.current_price ?? 0) "
        } else {
            lblPrice.text = data?.current_price?.convertToCurrency()
        }
        
        change24h = dt.price_change_percentage_24h ?? 0
        lblPricePrecentage.text = "\(String(format: "%.2f", change24h))" + "%"
        checkPrecentage(precentage: change24h)
        guard let imgUrl = dt.image else { return }
        let urlImg = URL(string:(imgUrl))!
        if let data = try? Data(contentsOf: urlImg) {
            self.imgIcon.image  = UIImage(data: data)
        }
        
       getDetail()
    }

    func getDetail() {
        showLoading()
        viewModel.getMarketDetail(id: coinId)
    }
  
    func onFinishLoadMarketDetail(data: MarketDetail) {
        self.dismiss(animated: true, completion: nil)
        self.lblDescription.text = data.description.en
        self.lblPricePrecentage.text = "\(String(format: "%.2f", change24h))" + "%"

        self.change24h = data.market_data.price_change_percentage_24h ?? 0
        self.change7d = data.market_data.price_change_percentage_7d ?? 0
        self.change30d = data.market_data.price_change_percentage_30d ?? 0
        self.change1y = data.market_data.price_change_percentage_1y ?? 0
    }
    
    func onFailRequest(msg: String) {
        self.dismiss(animated: true, completion: nil)
        Toast(text: msg, duration: Delay.short).show()
    }
    
    @IBAction func priceChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.lblPricePrecentage.text = "\(String(format: "%.2f", change24h))" + "%"
            checkPrecentage(precentage: change24h)
            break
        case 1:
            self.lblPricePrecentage.text = "\(String(format: "%.2f", change7d))" + "%"
            checkPrecentage(precentage: change7d)
            break
        case 2:
            self.lblPricePrecentage.text = "\(String(format: "%.2f", change30d))" + "%"
            checkPrecentage(precentage: change30d)
            break
        case 3:
            self.lblPricePrecentage.text = "\(String(format: "%.2f", change1y))" + "%"
            checkPrecentage(precentage: change1y)
            break
        default:
            break
        }
    }
    
    func checkPrecentage(precentage : Double) {
        if precentage < 0 {
            lblPricePrecentage.textColor = UIColor.red
        } else {
            lblPricePrecentage.textColor = UIColor.systemGreen
        }
    }
}
