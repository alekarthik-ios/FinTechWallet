//
//  WalletViewModelTests.swift
//  FeatureWallet
//
//  Created by Karthik Ale on 8/23/26.
//

import XCTest
import SwiftUI
import SharedModels
@testable import FeatureWallet

@MainActor
final class WalletViewModelTests: XCTestCase {
    var sut: WalletViewModel!     // "system under test"
    var mockUseCase: MockWalletUseCase!
    
    override func tearDown() {
        sut = nil
        mockUseCase = nil
        super.tearDown()
    }
    
    override func setUp() async throws {
        try await super.setUp()
        mockUseCase = MockWalletUseCase()
        sut = WalletViewModel(walletUseCase: mockUseCase)
    }
    
    func test_initialState_isIdle() {                           //test 1
        if case .idle = sut.state {
            //pass
        } else {
            XCTFail("Expected idle, got \(sut.state)")
        }
    }
    
    func test_fetchBalance_success_setsLoadedState() async{     //test 2
        
        let wallet = Wallet(userId: "1", balance: 143.10, currency: "USD")
        let transactions: [SharedModels.Transaction] = [
            Transaction(id: UUID(), amount: 10.0, recipient: "mike", status: .completed, timestamp: Date())
        ]
        let dashboard = WalletDashboard(wallet: wallet, transactions: transactions)
        mockUseCase.resultToReturn = dashboard
        
        await sut.fetchBalance()
        
        if case .loaded(let balance, let transactions) = sut.state {
            XCTAssertEqual(balance, "$143.10")
            XCTAssertEqual(transactions.count, 1)
        }else {
            XCTFail("Expected loaded, got \(sut.state)")
        }
        
    }
    
    
        func test_fetchBalance_failure_setsErrorState() async{
            
            mockUseCase.errorToThrow = NSError(domain: "", code: 0, userInfo: nil)
            
            await sut.fetchBalance()
            
            if case .error = sut.state {
            } else {
                XCTFail("Expected error, got \(sut.state)")
            }
        }
    
    
}
