//
//  SendMoneyError.swift
//  FeatureSendMoney
//
//  Created by Karthik Ale on 11/21/26.
//


import Foundation

public enum SendMoneyError: LocalizedError{
    case invalidAmount
    case invalidRecipientID
    case notAuthenticated
    
    public var errorDescription: String?{
        switch self {
        case .invalidAmount:
            return "Enter an amount greater than zero, with up to 2 decimal places."
        case .invalidRecipientID:
            return "We couldn't find this recipient. Check the details and try again."
        case .notAuthenticated:
            return "Your session has expired. Please log in again."
        }
        
        
    }
}
