//
//  Extention.swift
//  CoinTred
//
//  Created by MAC on 16/03/22.
//

import Foundation

extension Double {
    func convertToCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        let newSelf = floor(self)

        return " \((formatter.string(from: newSelf as NSNumber) ?? "0").replacingOccurrences(of: ".", with: ","))"
    }
    
    func convertToRpCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        formatter.maximumFractionDigits = 0

        let text = "Rp".localized() + " \((formatter.string(from: self as NSNumber) ?? "").replacingOccurrences(of: ".", with: ","))"
        if text.contains("-") {
            return "-\(text.replacingOccurrences(of: "-", with: ""))"
        } else {
            return text
        }
    }
}
