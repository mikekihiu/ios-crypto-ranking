//
//  CoinsListView.swift
//  CoinRanking
//
//  Created by Mike Kihiu on 03/03/2025.
//

import SwiftUI

struct CoinsListView: View {
   
    var viewModel: CoinsViewModel
    
    var body: some View {
        List(viewModel.coins) { coin in
            CoinRowView(coin: coin)
                .onAppear {
                    viewModel.checkPagination(at: coin)
                }
                .swipeActions(edge: .trailing) {
                    Button {
                        viewModel.toggleFavorite(coin)
                    } label: {
                        Image(systemName: coin.isFavorite ? "heart.slash.fill" : "heart.fill")
                            .tint(coin.isFavorite ? .gray : .green)
                    }
                }
                .listRowSeparator(.hidden)
        }
        .listStyle(.plain)

    }
}
