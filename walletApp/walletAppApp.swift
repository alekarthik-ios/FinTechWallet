//
//  walletAppApp.swift
//  walletApp
//
//  Created by Karthik Ale on 7/26/26.
//

import SwiftUI

@main
struct walletAppApp: App {
    @StateObject private var coordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            switch coordinator.appState {
                case .login:
                coordinator.makeLoginView()
                
                case .wallet:
                coordinator.makeWalletView()
                
                case .sendMoney:
                coordinator.makeSendMoneyView()
            }
        }
    }
}
