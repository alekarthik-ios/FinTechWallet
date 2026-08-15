//
//  MockNetworkClient.swift
//  FeatureLogin
//
//  Created by karthik Ale on 8/3/26.
//

import Foundation
import CoreNetworking
import SharedModels

public class MockNetworkClient: NetworkClientProtocol {
    
    var resultToReturn: Any?
    var errorToReturn: Error?
    
    public init() {}
    
    public func request<T: Decodable>(endpoint: Endpoint) async throws -> T {
        if let errorToReturn = self.errorToReturn {
            throw errorToReturn
        }
        guard let result = resultToReturn as? T else {
            fatalError("MockNetworkClient: resultToReturn not set or wrong type")
        }
        return result
    }
}
