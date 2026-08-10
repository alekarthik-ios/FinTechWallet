//
//  SendMoneyUseCase.swift
//  FeatureSendMoney
//
//  Created by Karthik Ale on 8/9/26.
//

import Foundation
import SharedModels
import CoreStorage

public enum SendMoneyError: Error{
    case invalidAmount
    case invalidRecipientID
    case notAuthenticated
}

public protocol SendMoneyUseCaseProtocol: Sendable {
    func execute(amount: Double, recipientId: String) async throws-> Transaction
}

public final class SendMoneyUseCase: SendMoneyUseCaseProtocol {
    let sendMoneyRepository: SendMoneyRepositoryProtocol
    let keychainService: KeychainServiceProtocol
    
    public init(sendMoneyRepository: SendMoneyRepositoryProtocol, keychainService: KeychainServiceProtocol) {
        self.sendMoneyRepository = sendMoneyRepository
        self.keychainService = keychainService
    }
    
    public func execute(amount: Double, recipientId: String) async throws -> Transaction {
        
        guard let data = try await keychainService.read(forKey: "authToken")else {
            throw SendMoneyError.notAuthenticated
        }
        guard amount > 0 else {
            throw SendMoneyError.invalidAmount
        }
        guard !recipientId.isEmpty else {
            throw SendMoneyError.invalidRecipientID
        }
        let token = try JSONDecoder().decode(AuthToken.self, from: data)
        let transaction = try await sendMoneyRepository.sendMoney(amount: amount, recipientId: recipientId, authToken: token.accessToken)
        return transaction
    }
}
