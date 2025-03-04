//
//  SyncCoinsUsecase.swift
//  CoinRanking
//
//  Created by Mike Kihiu on 03/03/2025.
//

import Foundation

struct SyncCoinsUsecase: SyncCoinsUsecaseProtocol {
    
    // Interface segregration
    var repository: SyncCoinsRepositoryProtocol = CoinRepository.shared
    
    func execute() async throws {
        try await repository.syncCoins()
    }
}
