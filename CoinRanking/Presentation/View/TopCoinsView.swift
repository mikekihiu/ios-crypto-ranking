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
            .onAppear {
                Task {
                    await viewModel.syncCoins()
                }
            }
            .alert("Coin Ranking", isPresented: viewModel.showAlert) {
                Text(viewModel.error?.localizedDescription ?? "")
                Button("Dismiss") { }
            }
    }
    
    private var rootView: some View {
        Group {
            if viewModel.animate {
                ProgressView()
            } else if viewModel.coins.isEmpty, !viewModel.isSearching {
                NoContentView(description: "No entries found. Please try again later")
            } else {
                Group {
                    if viewModel.coins.isEmpty {
                        Text("No results for \(viewModel.searchTextBinding.wrappedValue)" )
                    } else {
                        CoinsListView(viewModel: viewModel)
                    }
                }
                .navigationTitle("Top \(viewModel.coins.count) coins")
                .toolbar {
                    sortView
                }
                .searchable(text: viewModel.searchTextBinding, prompt: "Search...")
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
            Label("Show Menu", systemImage: "line.3.horizontal.decrease")
        }
    }
}


#Preview {
    NavigationStack {
        TopCoinsView()
    }
}
