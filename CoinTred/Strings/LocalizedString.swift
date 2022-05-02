//
//  LocalizedString.swift
//  CoinTred
//
//  Created by MAC on 30/04/22.
//

import Foundation

extension String {
//    enum Language : String {
//        case en, id
//    }
    
    func localized(lang: String) -> String {
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}
