//
//  LoginUseCase.swift
//  FeatureLogin
//
//  Created by karthik Ale on 8/3/26.
//
import Foundation
import SharedModels
import CoreStorage


public protocol LoginUseCaseProtocol: Sendable {
    func execute(email: String, password: String) async throws -> AuthToken
}

public final class LoginUseCase: LoginUseCaseProtocol {
    private let repository: LoginRepositoryProtocol
    private let keychain: KeychainServiceProtocol
    
    public init(repository: LoginRepositoryProtocol, keychain: KeychainServiceProtocol) {
        self.repository = repository
        self.keychain = keychain
    }
    
    public func execute(email: String, password: String) async throws -> AuthToken {
        
        let token = try await repository.login(email: email, password: password)
        let data = try JSONEncoder().encode(token)   //AuthToken -> Data
        try keychain.save(data: data, forKey: "authToken")
        return token
    }
}

