//
//  NumbersFormatter.swift
//  CoinRanking
//
//  Created by Mike Kihiu on 03/03/2025.
//

import Foundation

struct NumbersFormatter {
    
    static func currency(for value: String) -> String? {
        guard let dPrice = Double(value) else { return nil }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$ "
        formatter.maximumFractionDigits = 2
        formatter.roundingMode = .halfUp
        return formatter.string(from: NSNumber(value: dPrice))
    }
    
    static func number(for value: String) -> String? {
        guard let iPrice = Int(value) else { return nil }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: iPrice))
    }
}
