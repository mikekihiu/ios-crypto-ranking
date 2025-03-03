//
//  CoinRowView.swift
//  CoinRanking
//
//  Created by Mike Kihiu on 03/03/2025.
//

import SwiftUI

struct CoinRowView: View {
    
    let coin: Coin
    
    var body: some View {
        // Remove disclosure arrow
        ZStack {
            rowContent
            NavigationLink {
                CoinDetailView(coin: coin)
            } label: {
                //
            }
            .opacity(0)
        }
    }
    
    private var rowContent: some View {
        HStack(spacing: 16) {
            AsyncImage(url: URL(string: coin.pngUrl)) { image in
                image
                    .resizable()
                    .frame(width: 80, height: 80)
            } placeholder: {
                ProgressView()
            }
            
            VStack(alignment: .leading, spacing: 8){
                Text(coin.name)
                    .font(.headline)
                if let price = NumbersFormatter.currency(for: coin.price) {
                    Text(price)
                        .font(.caption)
                }
                if let volume = NumbersFormatter.number(for: coin.dailyVolume) {
                    Text(volume)
                        .font(.caption)
                }
            }
            
            Spacer()
            
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color("listItemBackgroundColor"))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(color: Color(.separator).opacity(0.5), radius: 4, x: 0, y: 0)
    }
}

#Preview {
    NavigationStack {
        CoinRowView(coin: previewCoin)
            .padding()
    }
}
