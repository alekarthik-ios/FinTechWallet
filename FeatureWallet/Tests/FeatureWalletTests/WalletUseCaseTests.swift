//
//  WalletUSecaseTests.swift
//  FeatureWallet
//
//  Created by Karthik Ale on 8/13/26.
//

import XCTest
import CoreStorage
@testable import FeatureWallet
import SharedModels

final class WalletUseCaseTests: XCTestCase {
    
    var mockRepo: MockWalletRepository!
    var mockKeychain: MockKeychainService!
    var useCase: WalletUseCase!
    
    override func setUp(){
        mockRepo = MockWalletRepository()
        mockKeychain = MockKeychainService()
        useCase = WalletUseCase(walletRepository: mockRepo, keychainService: mockKeychain)
    }
    
    
    func test_execute_returnsWalletDashboard() async throws {
        
        let fakeToken = AuthToken(
            userId: "1", accessToken: "demo", expiryDate: Date()
        )
        
        let encodedToken = try JSONEncoder().encode(fakeToken)
        
        mockKeychain.dataToReturn = encodedToken
        
        mockRepo.walletToReturn = Wallet(userId: "1", balance: 100.0, currency: "USD")
        
        mockRepo.transactionsToReturn = [
            Transaction(
                id: UUID(),
                amount: 50.0,
                recipient: "Amazon",
                status: .completed,
                timestamp: Date()
            )
        ]
        
        let result = try await useCase.execute()
        
        XCTAssertEqual(result.wallet.balance, 100.00)
        XCTAssertEqual(result.transactions.count, 1)
        
        
    }
    
    func test_execute_throwsNotAuthenticated_whenNoToken() async{
        
        mockKeychain.dataToReturn = nil
        
        do{
            _ = try await useCase.execute()
            XCTFail("Expected to throw NotAuthenticatedError")
        }catch{
            XCTAssertEqual(error as? WalletError, .notAuthenticated)
        }
        
    }
    
    func test_execute_throws_whenRepoFails() async throws{
        
        let fakeToken = AuthToken(
            userId: "1", accessToken: "demo", expiryDate: Date()
        )
        
        let encodedToken = try JSONEncoder().encode(fakeToken)
        
        mockKeychain.dataToReturn = encodedToken
        
        mockRepo.errorToThrow = NSError(domain: "test", code: 1)
        
        
        do{
            _ = try await useCase.execute()
            XCTFail("Expected to throw error")
        }catch{
            XCTAssertFalse(error is WalletError)
        }
    }
}

