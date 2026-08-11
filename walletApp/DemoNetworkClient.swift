//
//  DemoNetworkClient.swift
//  walletApp
//
//  Created by Karthik Ale on 8/8/26.
//


import Foundation
import CoreNetworking
import SharedModels

final class DemoNetworkClient: NetworkClientProtocol {
    
    func request<T: Decodable>(endpoint: Endpoint) async throws -> T
    {
       switch endpoint {
       case .login:
           let token = AuthToken(
                userId: "1",
                accessToken: "demo-token",
                expiryDate: Date()
           )
           
           return token as! T
           
       case .getWallet:
           let wallet = Wallet(
            userId: "1",
            balance: 143.20,
            currency: "USD"
           )
           
           return wallet as! T
           
       case .sendMoney:
           let transaction = Transaction(
            id: UUID(),
            amount: 10.00,
            recipient: "demo-user",
            status: .completed,
            timestamp: Date()
           )
           
           return transaction as! T
           
       case .getTransactions:
           let transactions: [Transaction] = [
               Transaction(id: UUID(), amount: 10.00, recipient: "Karthikale", status: .completed, timestamp: Date()),
               Transaction(id: UUID(), amount: 25.50, recipient: "Amazon", status: .completed, timestamp: Date()),
               Transaction(id: UUID(), amount: 500.00, recipient: "Deposit", status: .pending, timestamp: Date())
           ]
           return transactions as! T
           
       default:
           fatalError("Endpoint not mocked")
        }
    }
    
}


