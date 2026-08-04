//
//  walletAppApp.swift
//  walletApp
//
//  Created by BHAVYA SUREPALLY on 7/26/26.
//

import SwiftUI

@main
struct walletAppApp: App {
    @StateObject private var coordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            coordinator.makeLoginView()
        }
    }
}
