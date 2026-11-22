//
//  FeatureSendMoney.swift
//  FeatureSendMoney
//
//  Created by Karthik Ale on 8/9/26.
//

import Foundation
import CoreNetworking
import SharedModels

public protocol SendMoneyRepositoryProtocol: Sendable{
    func sendMoney(amount: Decimal, recipientId: String, authToken: String) async throws -> Transaction
}

public final class SendMoneyRepository: SendMoneyRepositoryProtocol {
    let networkClient: NetworkClientProtocol
    
    public init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
    public func sendMoney(amount: Decimal, recipientId: String, authToken: String) async throws -> Transaction {
    
        
        guard let id = UUID(uuidString: recipientId) else {
            throw SendMoneyError.invalidRecipientID
        }
        let transaction: Transaction = try await networkClient.request(endpoint: .sendMoney(amount: amount, recipientId: id))
        return transaction
    }
}
