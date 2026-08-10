//
//  Transaction.swift
//  SharedModels
//
//  Created by Karthik Ale on 8/9/26.
//

import Foundation


public enum TransactionType: Codable, Sendable {
    case pending
    case completed
    case failed
}

public struct Transaction: Codable, Sendable {
    public let id: UUID
    public let amount: Double
    public let recipient: String
    public let status: TransactionType
    public var statusLabel: String{
     switch status {
        case .pending:
            return "Pending"
        case .completed:
            return "Completed"
        case .failed:
            return "Failed"
     }
    }
    public let timestamp: Date
    
    public init(id: UUID, amount: Double, recipient: String, status: TransactionType, timestamp: Date) {
        self.id = id
        self.amount = amount
        self.recipient = recipient
        self.status = status
        self.timestamp = timestamp
    }
}
