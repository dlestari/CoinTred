//
//  ViewController.swift
//  CoinTred
//
//  Created by MAC on 12/03/22.
//

import UIKit
import Toaster

class ViewController: BaseViewController {
    
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var lblEmptyData: UILabel!
    var marketList = [CoinMarketResponse]()
    var page = 0
    var limit = 15
    var isLoading = false
    
    private lazy var paginationView: LoadingView = {
        let view = LoadingView(height: 24)
        view.hideLoading()
        return view
    }()
    
    private lazy var viewModel: MarketViewModel = {
        let viewModel = MarketViewModel(service: CoinService())
        viewModel.didFinishLoadDataMarket = self.onFinishLoadData
        viewModel.didFailRequest = self.onFailRequest
        return viewModel
    }()
 
    let activityIndicator : UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView()
        ai.color = UIColor.blue
        ai.hidesWhenStopped = true
        return ai
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {
        setupTableView()
        showLoading()
    }

    func setupTableView() {
        listTableView.isHidden = true
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.tableFooterView = paginationView
        listTableView.backgroundView = activityIndicator
        listTableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        listTableView.register(UINib(nibName: "CoinViewCell", bundle: nil), forCellReuseIdentifier: "CoinViewCell")
    }

    func fetchData(pagination : Int) {
        viewModel.getCoinMarket(country: "usd",page: pagination,limit: limit, order: "market_cap_desc")
    }

    func onFinishLoadData(data: [CoinMarketResponse]) {
        self.dismiss(animated: true, completion: nil)
        self.lblEmptyData.isHidden = true
        self.paginationView.hideLoading()
        
        self.isLoading = false
        self.listTableView.isHidden = false
        if page == 0 {
            self.marketList = []
        } else {
            self.page += 1
        }
        self.marketList += data
        self.listTableView.reloadData()
    }

    func onFailRequest(msg: String) {
        self.dismiss(animated: true, completion: nil)
        self.lblEmptyData.isHidden = false
        Toast(text: msg, duration: Delay.short).show()
    }
}

extension ViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return marketList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoinViewCell", for: indexPath) as! CoinViewCell
        cell.setupData(data: marketList[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.data = marketList[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let height = scrollView.frame.size.height
        let contentHeight = scrollView.contentSize.height
        let reachedBottom = (offsetY + height) > contentHeight
        if reachedBottom, !isLoading {
            isLoading = true
            paginationView.showLoading()
            page += 1
            fetchData(pagination: page)
        }
    }
}
