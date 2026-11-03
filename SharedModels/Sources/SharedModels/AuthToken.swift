//
//  AuthToken.swift
//  SharedModels
//
//  Created by Karthik Ale on 8/2/26.
//

import Foundation

public struct AuthToken: Codable, Sendable {
     public let userId: String
     public let accessToken: String
     public let expiryDate: Date
 
    public init(userId: String, accessToken: String, expiryDate: Date){
        self.userId = userId
        self.accessToken = accessToken
        self.expiryDate = expiryDate
    }
}


