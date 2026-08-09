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
import FeatureWallet

enum AppState{
    case login
    case wallet

}

@MainActor
final class AppCoordinator: ObservableObject {
    @Published var appState: AppState = .login
    
    func makeLoginView() -> some View {
        let network = DemoNetworkClient()
        let repo = LoginRepository(networking: network)
        let keychain = KeychainService()
        let useCase = LoginUseCase(repository: repo, keychain: keychain)
        let viewModel = LoginViewModel(useCase: useCase)
        viewModel.onLoginSuccess = { [weak self] in
            self?.appState = .wallet
            
        }
        
        return LoginView(viewModel: viewModel)
    }
    
    func makeWalletView() -> some View {
        let network = DemoNetworkClient()
        let repo = WalletRepository(networkClient: network)
        let keychain = KeychainService()
        let useCase = WalletUseCase(walletRepository: repo, KeychainService: keychain)
        let viewModel = WalletViewModel(walletUseCase: useCase)
        
        return WalletView(viewModel: viewModel)
    }
    
}
