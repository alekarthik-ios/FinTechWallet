//
//  MockSendMoneyUseCase.swift
//  FeatureSendMoney
//
//  Created by karthik Ale on 9/12/26.
//

import Foundation
import SharedModels
@testable import FeatureSendMoney

@MainActor
final class MockSendMoneyUseCase: SendMoneyUseCaseProtocol, @unchecked Sendable {
    
    var executeCallCount: Int = 0
    var resultToreturn: Transaction?
    var errorToReturn: Error?
    var delay: Duration = .zero
    
    var captureAmount: Double?
    var captureRecipient: String?
    
    func execute(amount: Double, recipientId: String) async throws -> Transaction {
        executeCallCount += 1
        captureAmount = amount
        captureRecipient = recipientId
        try await Task.sleep(for: delay)
        if let errorToReturn = errorToReturn {
            throw errorToReturn
        }
        return resultToreturn!
    }
}
