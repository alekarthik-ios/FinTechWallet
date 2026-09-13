//
//  SendMoneyViewModelTests.swift
//  FeatureSendMoney
//
//  Created by Karthik Ale on 9/12/26.
//

import XCTest
import SharedModels
@testable import FeatureSendMoney

@MainActor
final class SendMoneyViewModelTests: XCTestCase {
    
    var sut: SendMoneyViewModel!    //system under test
    var mockUseCase: MockSendMoneyUseCase!
    
    override func tearDown() {
        sut = nil
        mockUseCase = nil
        super.tearDown()
    }
    
    override func setUp() async throws {
        try await super.setUp()
        mockUseCase = MockSendMoneyUseCase()
        sut = SendMoneyViewModel(sendMoneyUseCase: mockUseCase)
    }
    
    
    func test_initialState_isIdle() {           //Test 1
        if case .idle = sut.state {} else {
            XCTFail("Expected idle, got \(sut.state)")
        }
    }
    
    func test_sendMoney_success() async {       //Test 2
        
        mockUseCase.resultToreturn = Transaction(id: UUID(), amount: 10.0, recipient: "mike", status: .completed, timestamp: Date())
        sut.amount = "100"
        sut.recipientId = "123"
        
        await sut.sendMoney()
        
        if case .success = sut.state {} else {
            XCTFail("Expected success, got \(sut.state)")
        }
        
    }
    
    func test_sendMoney_invalidAmount_failswithoutCallingUseCase() async {
        
        sut.amount = ""
        
        await sut.sendMoney()
        
        if case .failure = sut.state {} else {
            XCTFail("Expected failure, got \(sut.state)")
        }
        
        XCTAssertNil(mockUseCase.captureAmount, "use case should not be called for invalid input")
        
        
    }
    
    func test_SendMoney_useCasethrows_setsFailureState() async {
        
        sut.amount = "100"
        sut.recipientId = "123"
        mockUseCase.errorToReturn = NSError(domain: "test", code: 0, userInfo: nil)
        
        await sut.sendMoney()
        
        if case .failure = sut.state {} else {
            XCTFail("Expected failure, got \(sut.state)")
        }
    }
    
}

