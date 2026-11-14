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
    @Published var isOffline: Bool = false
    private var loginViewModel: LoginViewModel?
    private var walletViewModel: WalletViewModel?
    private var sendMoneyViewModel: SendMoneyViewModel?
    
    @Published var appState: AppState = .login
    private var sendMoneyPrefill: (recipientId: String?, amount: Decimal?)? = nil
    private var pendingLink: DeepLink? = nil
    
    func makeLoginView() -> some View {
        if let viewModel = loginViewModel{
            return LoginView(viewModel: viewModel)
        }else{
            let network = DemoNetworkClient()
            let repo = LoginRepository(networking: network)
            let keychain = KeychainService()
            let useCase = LoginUseCase(repository: repo, keychain: keychain)
            let viewModel = LoginViewModel(useCase: useCase)
            viewModel.onLoginSuccess = { [weak self] in
                self?.loginViewModel = nil
                if let link = self?.pendingLink {
                    self?.pendingLink = nil
                    self?.appState = .wallet
                    self?.handle(link)
                }else{
                    self?.appState = .wallet
                }
                
            }
            loginViewModel = viewModel
            return LoginView(viewModel: viewModel)
        }
    }
    
    func makeWalletView() -> some View {
        
        if let viewModel = walletViewModel{
            return WalletView(viewModel: viewModel)
        }else{
            let network = DemoNetworkClient()
            let repo = WalletRepository(networkClient: network)
            let keychain = KeychainService()
            let useCase = WalletUseCase(walletRepository: repo, keychainService: keychain)
            let viewModel = WalletViewModel(walletUseCase: useCase)
            viewModel.onSendMoneyTapped = { [weak self] in
                print("🚪 Leaving Wallet: emptying the wardrobe")
                self?.walletViewModel = nil   //empty VM before screen change to sendmoney
                self?.appState = .sendMoney
            }
            walletViewModel = viewModel
            return WalletView(viewModel: viewModel)
        }
        
    }
    
    func handle(_ link: DeepLink){
        
        if appState == .login{
            pendingLink = link
            return
        }
    
        switch link {
            case .wallet:
                appState = .wallet
            case .sendMoney(let recipientId, let amount):
                sendMoneyPrefill = (recipientId, amount)
                appState = .sendMoney
        }
    }
    
    func makeSendMoneyView() -> some View {
        
        if let viewModel = sendMoneyViewModel{
            return SendMoneyView(viewModel: viewModel)
        }else{
            let network = DemoNetworkClient()
            let repo = SendMoneyRepository(networkClient: network)
            let keychain = KeychainService()
            let useCase = SendMoneyUseCase(sendMoneyRepository: repo, keychainService: keychain)
            let viewModel = SendMoneyViewModel(sendMoneyUseCase: useCase)
            
            if let sendMoneyPrefill {
                viewModel.recipientId = sendMoneyPrefill.recipientId ?? ""
                viewModel.amount = sendMoneyPrefill.amount.map{"\($0)"} ?? ""
                self.sendMoneyPrefill = nil
            }
            
            viewModel.onBackTapped = { [weak self] in
                self?.sendMoneyViewModel = nil
                self?.appState = .wallet
            }
            sendMoneyViewModel = viewModel
            return SendMoneyView(viewModel: viewModel)
        }
        
    }
    
    
}
