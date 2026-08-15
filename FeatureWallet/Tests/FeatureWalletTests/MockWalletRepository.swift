//
//  MockWalletRepository.swift
//  FeatureWallet
//
//  Created by karthik Ale on 8/13/26.
//

import Foundation
import SharedModels
import CoreNetworking
import FeatureWallet


final class MockWalletRepository: WalletRepositoryProtocol, @unchecked Sendable {
    
    var walletToReturn: Wallet?
    var transactionsToReturn: [Transaction] = []
    var errorToThrow: Error?
    
    func fetchBalance(authToken: String) async throws -> Wallet {
        if let errorToThrow = errorToThrow {
            throw errorToThrow
        }
        return walletToReturn!
    }
    
    func fetchTransactions(authToken: String) async throws -> [Transaction] {
        if let errorToThrow = errorToThrow {
            throw errorToThrow
        }
        return transactionsToReturn
    }
    
    
}
