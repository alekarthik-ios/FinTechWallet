//
//  Wallet.swift
//  SharedModels
//
//  Created by Karthik Ale on 8/8/26.
//

import Foundation

public struct Wallet: Codable, Sendable {
    public var userId: String
    public var balance: Double
    public var currency: String
    
    public init(userId: String, balance: Double, currency: String) {
        self.userId = userId
        self.balance = balance
        self.currency = currency
    }
}
