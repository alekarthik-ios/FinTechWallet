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
import FeatureSendMoney

enum AppState{
    case login
    case wallet
    case sendMoney

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
        let useCase = WalletUseCase(walletRepository: repo, keychainService: keychain)
        let viewModel = WalletViewModel(walletUseCase: useCase)
        viewModel.onSendMoneyTapped = { [weak self] in
            self?.appState = .sendMoney
        }
        return WalletView(viewModel: viewModel)
    }
    
    func makeSendMoneyView() -> some View {
        let network = DemoNetworkClient()
        let repo = SendMoneyRepository(networkClient: network)
        let keychain = KeychainService()
        let useCase = SendMoneyUseCase(sendMoneyRepository: repo, keychainService: keychain)
        let viewModel = SendMoneyViewModel(sendMoneyUseCase: useCase)
        
        viewModel.onBackTapped = { [weak self] in
            self?.appState = .wallet
        }
        
        return SendMoneyView(viewModel: viewModel)
    }
    
}
