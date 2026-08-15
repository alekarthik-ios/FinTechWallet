//
//  MockKeychainService.swift
//  FeatureWallet
//
//  Created by Karthik Ale on 8/13/26.
//


import CoreStorage
import Foundation


final class MockKeychainService: KeychainServiceProtocol, @unchecked Sendable {
    
    var dataToReturn: Data?
    var savedData: Data?
    var didDeleteData: String? = nil
    
    func save(data: Data, forKey key: String) throws {
        savedData = data
    }
    
    func read(forKey: String) throws -> Data? {
        return dataToReturn
    }
    
    func delete(forKey: String) throws {
        didDeleteData = forKey
    }
    
}
