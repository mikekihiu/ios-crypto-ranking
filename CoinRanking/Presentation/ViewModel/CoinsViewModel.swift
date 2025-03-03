//
//  CoinsViewModel.swift
//  CoinRanking
//
//  Created by Mike Kihiu on 03/03/2025.
//

import Foundation
import Combine
import SwiftUI

@Observable
final class CoinsViewModel {
    
    private var allCoins: [Coin] = []
    private var subscription: AnyCancellable?
    
    var currentPage = 1
    var error: Error?
    var animate = true
    var sorter: CoinSorter = .rankAscending
    
    let getUsecase: GetCoinsUseCaseProtocol
    let syncUsecase: SyncCoinsUsecaseProtocol
    let toggleFavoriteUsecase: ToggleFavoriteCoinUsecaseProtocol
    let tab: Tab
    
    // Filtered by specified criteria
    var coins: [Coin] {
        let limit = min(allCoins.count, currentPage * 20)
        return Array(allCoins.sorted(using: sorter.descriptor).prefix(upTo: limit))
    }
    
    var showAlert: Binding<Bool> {
        Binding {
            self.error != nil
        } set: { _ in
            self.error = nil
        }
    }
    
    init(
        getUsecase: GetCoinsUseCaseProtocol = GetCoinsUsecase(),
        syncUsecase: SyncCoinsUsecaseProtocol = SyncCoinsUsecase(),
        toggleFavoriteUsecase: ToggleFavoriteCoinUsecaseProtocol = ToggleFavoriteCoinUsecase(),
        tab: Tab
    ) {
        self.getUsecase = getUsecase
        self.syncUsecase = syncUsecase
        self.toggleFavoriteUsecase = toggleFavoriteUsecase
        self.tab = tab
        subscribeToCoinUpdates()
    }
    
    private func subscribeToCoinUpdates() {
        subscription = getUsecase.execute().sink { [weak self] value in
            self?.allCoins = value.filter { self?.tab == .favorites ? $0.isFavorite : true }
        }
    }
    
    func syncCoins() async {
        if !allCoins.isEmpty {
            animate = false
            return
        }
        do {
            try await syncUsecase.execute()
            animate = false
        } catch {
            animate = false
            self.error = error
        }
    }
    
    func checkPagination(at coin: Coin) {
        if let last = coins.last, last.id == coin.id {
            currentPage += 1
        }
    }
    
    func toggleFavorite(_ coin: Coin) {
        toggleFavoriteUsecase.execute(coin)
    }
    
    enum Tab: CaseIterable {
        case topCoins, favorites
    }
}


