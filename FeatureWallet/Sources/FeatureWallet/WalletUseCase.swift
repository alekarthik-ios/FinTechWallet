//
//  WalletUseCase.swift
//  FeatureWallet
//
//  Created by karthik Ale on 8/8/26.
//


import Foundation
import CoreStorage
import SharedModels

public enum WalletError: Error {
    case notAuthenticated
}

public protocol WalletUseCaseProtocol: Sendable {
    func execute() async throws -> Wallet
}

public final class WalletUseCase: WalletUseCaseProtocol {
    
    let walletRepository: WalletRepositoryProtocol
    let keychainService: KeychainServiceProtocol
    
    public init(walletRepository: WalletRepositoryProtocol, keychainService: KeychainServiceProtocol) {
        self.walletRepository = walletRepository
        self.keychainService = keychainService
        }
    public func execute() async throws -> Wallet {
        guard let data = try keychainService.read(forKey: "authToken") else {
            throw WalletError.notAuthenticated
        }
        
        let token = try JSONDecoder().decode(AuthToken.self, from: data)
        let wallet = try await walletRepository.fetchBalance(authToken: token.accessToken)
        
        return wallet
    }
    
}

