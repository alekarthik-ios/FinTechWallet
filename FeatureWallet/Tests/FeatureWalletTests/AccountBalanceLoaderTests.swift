
import Foundation
import XCTest
@testable import FeatureWallet

struct MockBalanceFetcher: BalanceFetcher {
    let balances: [String: Decimal]
    var failingId: String? = nil
    struct FetchFailed: Error{}
    
    func balance(for accountId: String) async throws -> Decimal {
        
        try await Task.sleep(for: .milliseconds(100))
        if accountId == failingId {
            throw FetchFailed()
        }
        return balances[accountId] ?? 0
    }
}
    

final class AccountBalanceLoaderTests: XCTestCase {
    
    //Test:1
    func test_loadsAllBalances_inParallel() async throws {
        //Arrange
        let fetcher = MockBalanceFetcher(balances: ["Paypal": 100, "Chase": 200, "Apple": 400])
        let loader = AccountBalanceLoader(fetcher: fetcher)
        let clock = ContinuousClock()
        
        //Act
        let start = clock.now
        let result = try await loader.loadBalances(for: ["Paypal", "Chase", "Apple"])
        let elapsed = clock.now - start
        
        //Assert
        XCTAssertEqual(result, ["Paypal": 100, "Chase": 200, "Apple": 400])
        XCTAssertLessThan(elapsed, .milliseconds(250))
    }
    
    //Test:2
    func test_oneAccountFails_wholeLoadThrows() async {
        //Arrange
        let fetcher = MockBalanceFetcher(balances: ["Paypal": 100, "Chase": 200, "Apple": 400], failingId: "Chase")
        let loader = AccountBalanceLoader(fetcher: fetcher)
        
        //Act+Assert
        do {
            _ = try await loader.loadBalances(for: ["Paypal", "Chase", "Apple"])
            XCTFail("Expected error but got none")
        }catch {
            XCTAssertTrue(error is MockBalanceFetcher.FetchFailed)
        }
        
    }
}
