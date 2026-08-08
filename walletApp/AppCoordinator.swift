//
//  File.swift
//  walletApp
//
//  Created by karthik Ale on 8/4/26.
//

import Foundation
import SwiftUI
import CoreNetworking
import FeatureLogin
import Combine
import CoreStorage

@MainActor
final class AppCoordinator: ObservableObject {
    
    func makeLoginView() -> some View {
        let network = NetworkClient(baseURL: "https://api.paypal.com")
        let repo = LoginRepository(networking: network)
        let keychain = KeychainService()
        let useCase = LoginUseCase(repository: repo, keychain: keychain)
        let viewModel = LoginViewModel(useCase: useCase)
        viewModel.onLoginSuccess = {
            print("Login success! Navigate here")
        }
        
        return LoginView(viewModel: viewModel)
    }
}
