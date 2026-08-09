//
//  keychainService.swift
//  CoreStorage
//
//  Created by Karthik Ale on 8/6/26.
//

import Foundation
import Security

public enum KeychainError: Error {
    case saveFailed
    case readFailed
    case deleteFailed
}

public protocol KeychainServiceProtocol: Sendable {
    func save(data: Data, forKey: String) throws
    func read(forKey: String) throws -> Data?
    func delete(forKey: String) throws
}

public final class KeychainService: KeychainServiceProtocol {
    public init() {}
    
    public func save(data: Data, forKey: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: forKey,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.saveFailed
        }
    }
    
    public func delete(forKey key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.deleteFailed
        }
        
    }
    
    public func read(forKey key: String) throws -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess else {
            if status == errSecItemNotFound {
                return nil
            } else {
                throw KeychainError.readFailed
            }
            
        }
        return result as? Data
    }
}


