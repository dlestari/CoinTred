//
//  Extention.swift
//  CoinTred
//
//  Created by MAC on 16/03/22.
//

import Foundation
import Localize_Swift

extension Double {
    func convertToCurrency() -> String {
        if Localize.currentLanguage() == "en" {
            let formatter = NumberFormatter()
            formatter.usesGroupingSeparator = true
            formatter.numberStyle = .currency
            formatter.locale = Locale.current
            let text = "\((formatter.string(from: self as NSNumber) ?? ""))"
            return text
        } else {
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
}
