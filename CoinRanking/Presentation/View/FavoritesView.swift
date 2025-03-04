//
//  FavoritesView.swift
//  CoinRanking
//
//  Created by Mike Kihiu on 03/03/2025.
//

import SwiftUI

struct FavoritesView: View {
    
    var viewModel: CoinsViewModel = .init(tab: .favorites)
    
    var body: some View {
        Group {
            if viewModel.coins.isEmpty {
                NoContentView(description: "No favorites yet")
            } else {
                CoinsListView(viewModel: viewModel)
            }
        }
        .navigationTitle("Favorites")
    }
}

#Preview {
    FavoritesView()
}
