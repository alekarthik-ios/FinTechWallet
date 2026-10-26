//
//  WalletLedger.swift
//  FeatureWallet
//
//  Created by Karthik Ale on 10/25/26.
//

import Foundation

public protocol PaymentAuthorizer: Sendable {
    func authorize(_ amount: Decimal) async throws
}

public enum LedgerError: Error {
    case insufficientFunds
}

public actor WalletLedger {
    public private(set) var balance: Decimal
    private let authorizer: PaymentAuthorizer
    
    public init(balance: Decimal, authorizer: PaymentAuthorizer){
        self.balance = balance
        self.authorizer = authorizer
    }
    
    public func withdraw(_ amount: Decimal) async throws {
        guard balance >= amount else {
            throw LedgerError.insufficientFunds
        }
        
        balance -= amount
        
        do{
            try await authorizer.authorize(amount)
        }catch {
            balance += amount
            throw error
        }
        
    }
}
