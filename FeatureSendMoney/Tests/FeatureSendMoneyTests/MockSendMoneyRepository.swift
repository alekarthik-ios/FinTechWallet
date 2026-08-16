//
//  MockSendMoneyRepository.swift
//  FeatureSendMoney
//
//  Created by Karthik Ale on 8/15/26.
//

import Foundation
import SharedModels
import FeatureSendMoney


final class MockSendMoneyRepository: SendMoneyRepositoryProtocol, @unchecked Sendable {
    
    var transactionToReturn: Transaction?
    var errorToThrow: Error?
    
    func sendMoney(amount: Double, recipientId: String, authToken: String) async throws -> Transaction {
        if let errorToThrow = errorToThrow {
            throw errorToThrow
        }
        return transactionToReturn!
    }
    
    
    
    
}
