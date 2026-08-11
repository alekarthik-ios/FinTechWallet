//
//  WalletViewModel.swift
//  FeatureWallet
//
//  Created by Karthik ale on 8/8/26.
//

import Foundation
import Combine
import SharedModels

@MainActor
public final class WalletViewModel: ObservableObject {
    
    let walletUseCase: WalletUseCaseProtocol
    public init (walletUseCase: WalletUseCaseProtocol) {
        self.walletUseCase = walletUseCase
    }

    
    @Published public var balance: String = "0.00"
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?
    @Published public var transactions: [Transaction] = []
    
    public var onSendMoneyTapped:(() -> Void)?
    
    
    public func fetchBalance() async {
        isLoading = true
        do {
            let dashboard = try await walletUseCase.execute()
            self.balance = String(format: "$%.2f", dashboard.wallet.balance)
            self.transactions = dashboard.transactions
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    
}
