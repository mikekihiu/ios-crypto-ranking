//
//  CoinRepository.swift
//  CoinRanking
//
//  Created by Mike Kihiu on 03/03/2025.
//

import Foundation
import Combine

final class CoinRepository: CoinRepositoryProtocol {
    
    private var coins: CurrentValueSubject<[Coin], Never> = .init([])
    private let coinsApi = CoinsApi()
    
    var coinsPublisher: AnyPublisher<[Coin], Never> {
        coins.eraseToAnyPublisher()
    }
    
    // Singeton
    static let shared = CoinRepository()
    
    private init() { }

    func syncCoins() async throws {
        let request = try coinsApi.createRequest()
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(CoinResponse.self, from: data)
        if response.isSuccess {
            let limit = min(100, response.data.coins.count)
            coins.send(Array(response.data.coins.prefix(upTo: limit)))
        }
    }
    
    func toggleFavorite(_ coin: Coin) {
        coin.isFavorite.toggle()
        if let index = coins.value.firstIndex(where: { $0.uuid == coin.uuid }) {
            var temp = coins.value
            temp[index] = coin
            coins.send(temp)
        }
    }
}

// TODO: Set own API key
struct CoinsApi {
    
    private let url = "https://api.coinranking.com/v2/coins"
    private let key: String? = nil
    
    func createRequest() throws -> URLRequest {
        guard let key else {
            throw NSError(
                domain: "CoinRanking",
                code: 6174,
                userInfo: [NSLocalizedDescriptionKey: "API key is required at CoinsApi.swift > key"]
            )
        }
        guard let url = URL(string: url) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.setValue(key, forHTTPHeaderField: "x-access-token")
        
        return request
    }
}
