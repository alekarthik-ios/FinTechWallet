//
//  MockWalletUseCase.swift
//  FeatureWallet
//
//  Created by Karthik Ale on 8/23/26.
//

import Foundation
import FeatureWallet

@MainActor
final class MockWalletUseCase: WalletUseCaseProtocol {
    
    var resultToReturn: WalletDashboard?
    var errorToThrow: Error?
    
    func execute() async throws -> WalletDashboard {
        if let errorToThrow = errorToThrow {
            throw errorToThrow
        }
        return resultToReturn! //force unwrap
    }
}
