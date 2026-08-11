//
//  WalletRepository.swift
//  FeatureWallet
//
//  Created by Karthik Ale on 8/8/26.
//

import Foundation
import CoreNetworking
import SharedModels

public protocol WalletRepositoryProtocol: Sendable {
    
    func fetchBalance(authToken: String) async throws -> Wallet
    func fetchTransactions(authToken: String) async throws -> [Transaction]
}

public final class WalletRepository: WalletRepositoryProtocol {
    private let networkClient: NetworkClientProtocol
    
    
    public init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
    public func fetchBalance(authToken: String) async throws -> Wallet {
        return try await networkClient.request(endpoint: .getWallet)
    }
    
    public func fetchTransactions(authToken: String) async throws -> [Transaction] {
        return try await networkClient.request(endpoint: .getTransactions)
    }
}
