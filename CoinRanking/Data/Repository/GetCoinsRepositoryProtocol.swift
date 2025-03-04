//
//  GetCoinsRepositoryProtocol.swift
//  CoinRanking
//
//  Created by Mike Kihiu on 03/03/2025.
//

import Combine

protocol GetCoinsRepositoryProtocol {
    var coinsPublisher: AnyPublisher<[Coin], Never> { get }
}
