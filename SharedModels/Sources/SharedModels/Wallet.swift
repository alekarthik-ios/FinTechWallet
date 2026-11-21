//
//  Wallet.swift
//  SharedModels
//
//  Created by Karthik Ale on 8/8/26.
//

import Foundation

public struct Wallet: Codable, Sendable {
    public var userId: String
    public var balance: Decimal
    public var currency: String
    
    public init(userId: String, balance: Decimal, currency: String) {
        self.userId = userId
        self.balance = balance
        self.currency = currency
    }
}
