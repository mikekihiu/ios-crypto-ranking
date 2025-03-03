//
//  CoinsViewModelTests.swift
//  CoinRankingTests
//
//  Created by Mike Kihiu on 03/03/2025.
//

import Testing
@testable import CoinRanking
import Combine

struct CoinsViewModelTests {
    
    var viewModel: CoinsViewModel
    
    let mockGetUsecase = MockGetCoinsUsecase()
    let mockSyncUsecase = MockSyncCoinsUsecase()
    let mockToggleFavoriteUsecase = MockToggleFavoriteCoinUsecase()
    
    init() async {
        viewModel = CoinsViewModel(
            getUsecase: mockGetUsecase,
            syncUsecase: mockSyncUsecase,
            toggleFavoriteUsecase: mockToggleFavoriteUsecase,
            tab: .topCoins
        )
    }

    @Test
    func validateInitialState() async {
        #expect(viewModel.currentPage == 1)
        #expect(viewModel.error == nil)
        #expect(viewModel.coins.isEmpty)
        #expect(viewModel.tab == .topCoins)
        #expect(!viewModel.showAlert.wrappedValue)
        #expect(viewModel.sorter == .rankAscending)
    }
    
    @Test
    func testShowAlert() async {
        // Arrange
        #expect(!viewModel.showAlert.wrappedValue)
        
        // Act
        viewModel.error = SyncError.unknownExpectation
        
        // Assert
        #expect(viewModel.showAlert.wrappedValue)
    }
    
    @Test
    func syncWithFailure() async throws {
        // Arrange
        mockSyncUsecase.setUpFailure()
        
        // Act
        await viewModel.syncCoins()
        
        // Assert
        let syncError = try #require(viewModel.error as? SyncError)
        #expect(syncError == .networkFailure)
    }
    
    @Test
    func syncWithSuccess() async {
        // Arrange
        mockSyncUsecase.setUpSuccess()
        
        // Act
        await viewModel.syncCoins()
        
        // Assert
        #expect(viewModel.error == nil)
    }
}

// MARK: Mocks
extension CoinsViewModelTests {
    
    class MockGetCoinsUsecase: GetCoinsUseCaseProtocol {
        func execute() -> AnyPublisher<[CoinRanking.Coin], Never> {
            Just([]).eraseToAnyPublisher()
        }
    }
    
    class MockSyncCoinsUsecase: SyncCoinsUsecaseProtocol {
        
        private var expectation: TestExpectation?
        var syncedSuccessfully: Bool?
        
        func execute() async throws {
            guard let expectation else {
                syncedSuccessfully = nil
                throw SyncError.unknownExpectation
            }
            if expectation == .failure  {
                syncedSuccessfully = nil
                throw SyncError.networkFailure
            }
            syncedSuccessfully = true
        }
        
        func setUpSuccess() {
            expectation = .success
        }
        
        func setUpFailure() {
            expectation = .failure
        }
    }
    
    class MockToggleFavoriteCoinUsecase: ToggleFavoriteCoinUsecaseProtocol {
        
        func execute(_ coin: CoinRanking.Coin) {
            //
        }
    }
    
    enum TestExpectation {
        case success, failure
    }
    
    enum SyncError: Error {
        case networkFailure
        case decodingFailure
        case unknownExpectation
    }
}
