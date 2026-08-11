//
//  WalletDashboard.swift
//  FeatureWallet
//
//  Created by Karthik Ale on 8/10/26.
//


import SharedModels


public struct WalletDashboard: Sendable {
    public let wallet: Wallet
    public let transactions: [Transaction]
   
    public init(wallet: Wallet, transactions: [Transaction]) {
        self.wallet = wallet
        self.transactions = transactions
    }
}
