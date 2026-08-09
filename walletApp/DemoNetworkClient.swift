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
           
       default:
           fatalError("Endpoint not mocked")
        }
    }
    
}


