//
//  MoneyTests.swift
//  FeatureSendMoney
//
//  Created by karthik ale on 11/21/26.
//

import Foundation
import XCTest
import SharedModels
@testable import FeatureSendMoney



@MainActor
final class MoneyTests: XCTestCase{
    
    
    func testDecimalAddsExactly() {
        
        //Arrange
        let first = Decimal(string: "0.1")!
        let second = Decimal(string: "0.2")!
        
        let expected = Decimal(string: "0.3")!
        
        //Act
        let actual = first + second
        
        //Assert
        XCTAssertEqual(actual, expected)
        XCTAssertNotEqual(0.1 + 0.2, 0.3)
    }
    
    func testTransactionDecodesExactAmount() throws {
        
        let json = """
            {
             "id": "3F2504E0-4F89-11D3-9A0C-0305E82C3301",
             "amount": 12.34,
             "recipient": "bob",
             "status": "completed",
             "timestamp": 0
            }
            """
        let data = Data(json.utf8)
        let decoder = JSONDecoder()
        
        let transaction = try decoder.decode(Transaction.self, from: data)

        XCTAssertEqual(transaction.amount, Decimal(string: "12.34")!)
    }
    
    func testAmountWithLettersIsRejected() async {
        //Arrange
        let mockUseCase = MockSendMoneyUseCase()
        let sut = SendMoneyViewModel(sendMoneyUseCase: mockUseCase)
        
        sut.amount = "12abv"
        sut.recipientId = "bob"
        
        await sut.sendMoney()
        
        
        XCTAssertEqual(mockUseCase.executeCallCount, 0)
        
    }
}
