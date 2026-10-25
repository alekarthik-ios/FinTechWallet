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
    
   public enum WalletState {
        case idle
        case loading
        case loaded(balance: String, transactions: [Transaction])
        case error(String)
    }
    
    let walletUseCase: WalletUseCaseProtocol
    public init (walletUseCase: WalletUseCaseProtocol) {
        self.walletUseCase = walletUseCase
    }

    
    @Published public var state: WalletState = .idle
    
    public var onSendMoneyTapped:(() -> Void)?
    
    
    public func load() async {
        self.state = .loading
        
        do {
            let dashboard = try await walletUseCase.execute()
            self.state = .loaded(
                balance: String(format: "$%.2f", dashboard.wallet.balance),
                transactions: dashboard.transactions
            )
        } catch is CancellationError {
            self.state = .idle
        }catch {
            print("Wallet load ended with", error)
            self.state = .error("wallet.error")
        }
    
    }
    
    
}
