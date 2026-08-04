//
//  File.swift
//  FeatureLogin
//
//  Created by karthik Ale on 8/4/26.
//

import Foundation
import CoreNetworking
import SharedModels


@MainActor
public final class LoginViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    public var onLoginSuccess: (() -> Void)?
    
    private let useCase: LoginUseCaseProtocol
    
    public init(useCase: LoginUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func login() async {
        isLoading = true
        errorMessage = nil
        
        do {
            _ = try await useCase.execute (email: email, password: password)
            onLoginSuccess?()
        } catch {
                errorMessage = "Invalid Credentials"
        }
         
        
        isLoading = false
    }
}






