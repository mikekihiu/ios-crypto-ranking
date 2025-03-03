//
//  CoinDetailView.swift
//  CoinRanking
//
//  Created by Mike Kihiu on 03/03/2025.
//

import SwiftUI
import Charts

struct CoinDetailView: View {
    
    var coin: Coin
    
    var body: some View {
        VStack {
            Chart(coin.graph) { item in
                LineMark(
                    x: .value("time", item.id),
                    y: .value("value", item.value)
                )
            }
            .frame(height: 200)
            .padding()
            
            LabeledContent("Listed at", value: Date(timeIntervalSince1970: coin.listedAt).formatted(date: .abbreviated, time: .omitted))
            Divider()
            LabeledContent("Tier", value: "\(coin.tier)")
            LabeledContent("Rank", value: "\(coin.rank)")
            Divider()
            LabeledContent("Price", value: NumbersFormatter.currency(for: coin.price) ?? "")
            LabeledContent("Market Cap", value: NumbersFormatter.currency(for: coin.marketCap) ?? "")
            LabeledContent("24 Hour Volume", value: NumbersFormatter.number(for: coin.dailyVolume) ?? "")
            
            Spacer()
        }
        .padding()
        .navigationTitle(coin.name)
    }
}

#Preview {
    NavigationView {
        CoinDetailView(coin: previewCoin)
    }
}
