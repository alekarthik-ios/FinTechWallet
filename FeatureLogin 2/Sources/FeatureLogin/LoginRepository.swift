//
//  LoginRepository.swift
//  walletApp
//
//  Created by Karthik Ale on 8/2/26.
//


import Foundation
import CoreNetworking
import SharedModels


public protocol LoginRepositoryProtocol: Sendable {
        
    func login(email: String, password: String) async throws -> AuthToken
}

public final class LoginRepository: LoginRepositoryProtocol {
    
    private let networking: NetworkClientProtocol
    
    public init(networking: NetworkClientProtocol) {
        self.networking = networking
    }
    
    public func login(email: String, password: String) async throws -> AuthToken {
        
        return try await networking.request(
            endpoint: .login(email: email, password: password)
        )
        
    }
}
