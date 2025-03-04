//
//  GetCoinsUsecaseTests.swift
//  CoinRankingTests
//
//  Created by Mike Kihiu on 03/03/2025.
//

import Testing
@testable import CoinRanking
import Combine

final class GetCoinsUsecaseTests {
    
    var usecase = GetCoinsUsecase()
    let repository = MockRepository()
    var subscription: AnyCancellable?
    
    init() {
        usecase.repository = repository
    }

    @Test(arguments: Expectation.allCases)
    func execute(_ expectation: Expectation) {
        // Arrange
        repository.setUp(expectation)
        
        // Act
        subscription = usecase.execute().sink { result in
            // Assert
            #expect(result.count == expectation.resultCount)
        }
    }
}

// MARK: Mocks
extension GetCoinsUsecaseTests {
    
    class MockRepository: GetCoinsRepositoryProtocol {
        
        private var expectation: Expectation?
        
        func setUp(_ expectation: Expectation) {
            self.expectation = expectation
        }
        
        var coinsPublisher: AnyPublisher<[CoinRanking.Coin], Never> {
            Just(expectation == .someValueDataSet ? [previewCoin] : []).eraseToAnyPublisher()
        }
    }
    
    enum Expectation: CaseIterable {
        case emptyDataSet
        case someValueDataSet
        
        var resultCount: Int {
            switch self {
            case .emptyDataSet:
                return 0
            case .someValueDataSet:
                return 1
            }
        }
    }
}


