//
//  AuthToken.swift
//  SharedModels
//
//  Created by Karthik Ale on 8/2/26.
//

import Foundation

public struct AuthToken: Decodable {
     public var userId: String
     public var accessToken: String
     public var expiryDate: Date
 
    public init(userId: String, accessToken: String, expiryDate: Date){
        self.userId = userId
        self.accessToken = accessToken
        self.expiryDate = expiryDate
    }
}


