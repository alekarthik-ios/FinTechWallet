//
//  SendMoneyUseCaseTests.swift
//  FeatureSendMoney
//
//  Created by Karthik Ale on 8/15/26.
//

import XCTest
@testable import FeatureSendMoney
import CoreStorage
import SharedModels

final class SendMoneyUseCaseTests: XCTestCase {
    
    var mockRepo: MockSendMoneyRepository!
    var mockKeychain: MockKeychainService!
    var useCase: SendMoneyUseCase!
    
    override func setUp() {
        mockRepo = MockSendMoneyRepository()
        mockKeychain = MockKeychainService()
        useCase = SendMoneyUseCase(sendMoneyRepository: mockRepo, keychainService: mockKeychain)
    }
    
    func test_success_whenValidInput() async throws {
        
        let fakeToken = AuthToken(
            userId: "1", accessToken: "demo", expiryDate: Date()
        )
        
        let encodedToken = try JSONEncoder().encode(fakeToken)
        
        mockKeychain.dataToReturn = encodedToken
        
        mockRepo.transactionToReturn = Transaction(
                id: UUID(),
                amount: 50.0,
                recipient: "karthikale",
                status: .completed,
                timestamp: Date()
            )
    
        let result = try await useCase.execute(amount: 50.0, recipientId: "karthikale")
        
        XCTAssertEqual(result.amount, 50.0)
        XCTAssertEqual(result.recipient, "karthikale")
    }
    
    
    func test_throwsNotAuthenticated_whenNoToken() async throws {
        
        do {
            _ = try await useCase.execute(amount: 50.0, recipientId: "karthikale")
            XCTFail("Expected error not thrown")
        }catch {
            XCTAssertEqual(error as? SendMoneyError, .notAuthenticated)
        }
    }
    
    func test_throwsInvalidAmount_whenZeroOrNegative() async throws {
        
        let fakeToken = AuthToken(
            userId: "1", accessToken: "demo", expiryDate: Date()
        )
        
        let encodedToken = try JSONEncoder().encode(fakeToken)
        
        mockKeychain.dataToReturn = encodedToken
        
        
        do {
            _ = try await useCase.execute(amount: -40.0, recipientId: "karthikale")
            XCTFail("should have thrown")
        }catch {
            XCTAssertEqual(error as? SendMoneyError, .invalidAmount)
        }
    }
    
    func test_throwsInvalidRecipient_whenEmptyString() async throws {
        
        let fakeToken = AuthToken(
            userId: "1", accessToken: "demo", expiryDate: Date()
        )
        
        let encodedToken = try JSONEncoder().encode(fakeToken)
        
        mockKeychain.dataToReturn = encodedToken
        
        do {
            _ = try await useCase.execute(amount: 40.0, recipientId: "")
            XCTFail("should have thrown")
        }catch {
            XCTAssertEqual(error as? SendMoneyError, .invalidRecipientID)
        }
    }
}
