//
//  CoinViewCell.swift
//  CoinTred
//
//  Created by MAC on 12/03/22.
//

import UIKit

class CoinViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblCoinName: UILabel!
    @IBOutlet weak var lblSymbol: UILabel!
    @IBOutlet weak var lblChange24h: UILabel!
    @IBOutlet weak var container24h: UIView!
    @IBOutlet weak var lblPrice: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupShadow()
    }

    func setupShadow() {
        self.mainView.layer.shadowColor = UIColor.black.cgColor
        self.mainView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        self.mainView.layer.shadowOpacity = 0.2
        self.mainView.layer.shadowRadius = 2.0
    }

    
    func setupData(data : CoinMarketResponse) {
        let percentage24h = data.price_change_percentage_24h ?? 0
        let currentPrice = data.current_price ?? 0
        lblCoinName.text = data.name ?? ""
        lblSymbol.text = data.symbol?.uppercased()
        
        if currentPrice < 1 {
            lblPrice.text = "$\(data.current_price ?? 0) "
        } else {
            lblPrice.text = data.current_price?.convertToCurrency()
        }
        lblChange24h.text = "\(String(format: "%.2f", percentage24h))" + "%"
        if percentage24h < 0 {
            container24h.backgroundColor = UIColor.red
        } else {
            container24h.backgroundColor = UIColor.systemGreen
        }
        guard let imgUrl = data.image else { return }
        let urlImg = URL(string:(imgUrl))!
        if let data = try? Data(contentsOf: urlImg) {
            self.imgIcon.image  = UIImage(data: data)
        }
    }
    
}
