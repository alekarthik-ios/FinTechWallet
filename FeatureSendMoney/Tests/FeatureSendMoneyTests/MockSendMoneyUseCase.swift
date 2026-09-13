//
//  MockSendMoneyUseCase.swift
//  FeatureSendMoney
//
//  Created by karthik Ale on 9/12/26.
//

import Foundation
import SharedModels
import FeatureSendMoney

@MainActor
final class MockSendMoneyUseCase: SendMoneyUseCaseProtocol {
    
    var resultToreturn: Transaction?
    var errorToReturn: Error?
    
    var captureAmount: Double?
    var captureRecipient: String?
    
    func execute(amount: Double, recipientId: String) async throws -> Transaction {
        captureAmount = amount
        captureRecipient = recipientId
        if let errorToReturn = errorToReturn {
            throw errorToReturn
        }
        return resultToreturn!
    }
}
