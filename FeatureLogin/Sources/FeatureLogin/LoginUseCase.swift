//
//  LoginUseCase.swift
//  FeatureLogin
//
//  Created by karthik Ale on 8/3/26.
//
import Foundation
import SharedModels

public protocol LoginUseCaseProtocol: Sendable {
    func execute(email: String, password: String) async throws -> AuthToken
}

public final class LoginUseCase: LoginUseCaseProtocol {
    private let repository: LoginRepositoryProtocol
    
    public init(repository: LoginRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(email: String, password: String) async throws -> AuthToken {
        return try await repository.login(email: email, password: password)
    }
}

