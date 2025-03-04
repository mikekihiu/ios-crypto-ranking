//
//  GetCoinsUseCaseProtocol.swift
//  CoinRanking
//
//  Created by Mike Kihiu on 03/03/2025.
//


import Combine

protocol GetCoinsUseCaseProtocol {
    func execute() -> AnyPublisher<[Coin], Never>
}
