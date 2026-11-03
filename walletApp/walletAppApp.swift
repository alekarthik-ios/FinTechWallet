//
//  walletAppApp.swift
//  walletApp
//
//  Created by Karthik Ale on 7/26/26.
//

import SwiftUI
import Combine

@main
struct walletAppApp: App {
    @StateObject private var coordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            Group{
                switch coordinator.appState {
                case .login:
                    coordinator.makeLoginView()
                    
                case .wallet:
                    coordinator.makeWalletView()
                    
                case .sendMoney:
                    coordinator.makeSendMoneyView()
                }
            }
            .onOpenURL(perform: { url in
                print("Deep Link received", url)
            })
        }
    }
        
}

