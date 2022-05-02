//
//  BaseActivity.swift
//  CoinTred
//
//  Created by MAC on 27/04/22.
//

import UIKit
import SwiftEventBus

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SwiftEventBus.onMainThread(self, name: "REQUEST_TIMEOUT", handler: { _ in
            print("SwiftEventBus-called")
            self.showAlertTimeout()
        })
    }
   
    func showLoading() {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    func dismissLoading()  {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showAlertTimeout() {
        let alert = UIAlertController(title: "The request timed out.", message: "Plase try again!", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
