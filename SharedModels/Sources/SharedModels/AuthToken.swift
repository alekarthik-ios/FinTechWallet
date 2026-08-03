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
 
}
