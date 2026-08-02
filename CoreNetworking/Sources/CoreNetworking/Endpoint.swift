//
//  Endpoint.swift
//  CoreNetworking
//
//  Created by karthik Ale on 7/26/26.
//
import Foundation

public enum Endpoint
{
    case login (email: String, password: String)
    case getWallet
    case sendMoney (amount: Double, recipientId: UUID)
    
    
    
    public var path: String {
        switch self {
        case .login:
            return "/auth/login"
        case .getWallet:
            return "/wallet/balance"
        case .sendMoney:
            return "/send-money"
        }
        
    }
    
    public var method: String {
        switch self {
        case .login:
            return "POST"
        case .getWallet:
            return "GET"
        case .sendMoney:
            return "POST"
        }
    }
    
    public var body: [String: Any]? {
        
        switch self {
        case .login(let email, let password):
            return ["email": email, "password": password]
        case .getWallet:
            return nil
        case .sendMoney(let amount, let recipientId):
            return ["amount": amount, "recipientId": recipientId]
        }
    }
}
