//
//  AccountBalanceLoader.swift
//  FeatureWallet
//
//  Created by Karthik Ale on 11/8/26.
//

import Foundation

public protocol BalanceFetcher: Sendable {
    func balance(for accountId: String) async throws -> Decimal
}

public struct AccountBalanceLoader: Sendable {
    let fetcher: BalanceFetcher

    public init(fetcher: BalanceFetcher) {
        self.fetcher = fetcher
    }

    public func loadBalances(for accountIds: [String]) async throws -> [String: Decimal] {
        return try await withThrowingTaskGroup(of: (String, Decimal).self) { group in

            // Phase 1: launch one child per account
            for id in accountIds {
                group.addTask {
                    let value = try await self.fetcher.balance(for: id)
                    return (id, value)          // the child RETURNS its result
                }
            }

            // Phase 2: the parent collects results as they finish
            var results: [String: Decimal] = [:]
            for try await (id, value) in group {
                results[id] = value             // only the parent writes, one at a time
            }
            return results
        }
    }
}
