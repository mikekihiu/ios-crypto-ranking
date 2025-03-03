//
//  TopCoinsView.swift
//  CoinRanking
//
//  Created by Mike Kihiu on 03/03/2025.
//

import SwiftUI

struct TopCoinsView: View {
    
    var viewModel: CoinsViewModel = .init(tab: .topCoins)
    
    var body: some View {
        rootView
            .navigationTitle(viewModel.coins.isEmpty ? "" : "Top \(viewModel.coins.count) coins")
            .onAppear {
                Task {
                    await viewModel.syncCoins()
                }
            }
            .alert("Coin Ranking", isPresented: viewModel.showAlert) {
                Text(viewModel.error?.localizedDescription ?? "")
                Button("Dismiss") { }
            }
            .toolbar {
                sortView
            }
    }
    
    private var rootView: some View {
        Group {
            if viewModel.animate {
                ProgressView()
            } else if viewModel.coins.isEmpty {
                NoContentView(description: "No entries found. Please try again later")
            } else {
                CoinsListView(viewModel: viewModel)
            }
        }
    }
    
    private var sortView: some View {
        Menu {
            ForEach(CoinSorter.allCases, id: \.self) { sorter in
                Button("\(sorter.title) \(sorter == viewModel.sorter ? "✔️" : "")") {
                    viewModel.sorter = sorter
                }
            }
        } label: {
            Group {
                if viewModel.coins.isEmpty {
                    EmptyView()
                } else {
                    Label("Show Menu", systemImage: "line.3.horizontal.decrease")
                }
            }
        }
    }
}


#Preview {
    NavigationStack {
        TopCoinsView()
    }
}
