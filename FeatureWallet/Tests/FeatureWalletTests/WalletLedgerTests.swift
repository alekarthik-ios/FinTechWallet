//
//  WalletLedgerTests.swift
//  FeatureWallet
//
//  Created by Karthik Ale on 10/25/26.
//

import XCTest
@testable import FeatureWallet

struct SlowAuthorizer: PaymentAuthorizer {
    func authorize(_ amount: Decimal) async throws {
        try await Task.sleep(for: .milliseconds(100))
    }
}

struct DecliningAuthorizer: PaymentAuthorizer {
    struct Declined: Error {}
    func authorize(_ amount: Decimal) async throws {
        throw Declined()
    }
}

final class WalletLedgerTests: XCTestCase {
    func test_twoWithdrawalsAtOnce_neverGoBelowZero() async {
        let ledger = WalletLedger(balance: 100, authorizer: SlowAuthorizer())
        
        async let first: Void? = try? ledger.withdraw(80)
        async let second: Void? = try? ledger.withdraw(80)
        
        _ = await (first, second)
        
        let balance = await ledger.balance
        XCTAssertGreaterThanOrEqual(balance, 0)
    }
    
    func test_decliningWithdrawal_restoresBalance() async {
        let ledger = WalletLedger(balance: 100, authorizer: DecliningAuthorizer())
        do{
            try await ledger.withdraw(80)
            XCTFail("Expected error to be thrown")
        }catch{
            //expected, do nothing
        }
        
        let balance = await ledger.balance
        XCTAssertEqual(balance, 100)
        
        
    }

}




