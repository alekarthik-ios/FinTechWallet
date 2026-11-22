//
//  SendMoneyRepositoryTests.swift
//  FeatureSendMoney
//
//  Created by Karthik Ale on 11/21/26.
//

// SendMoneyRepositoryTests.swift
import XCTest
import CoreNetworking
import SharedModels
@testable import FeatureSendMoney

struct SpyNotConfigured: Error {}

// @unchecked: used by one test at a time, never shared across tasks
final class SpyNetworkClient: NetworkClientProtocol, @unchecked Sendable {
    var requestCount = 0
    var lastEndpoint: Endpoint?

    func request<T: Decodable>(endpoint: Endpoint) async throws -> T {
        requestCount += 1
        lastEndpoint = endpoint
        throw SpyNotConfigured()
    }
}

final class SendMoneyRepositoryTests: XCTestCase {
    func test_invalidRecipientID_throws_andNeverCallsNetwork() async {
        // Arrange
        let spy = SpyNetworkClient()
        let sut = SendMoneyRepository(networkClient: spy)

        // Act + Assert: it must throw the right error
        do {
            _ = try await sut.sendMoney(amount: 10, recipientId: "bob", authToken: "t")
            XCTFail("Expected invalidRecipientID")
        } catch {
            XCTAssertEqual(error as? SendMoneyError, .invalidRecipientID)
        }

        // Assert: the spy saw zero calls
        XCTAssertEqual(spy.requestCount, 0)
    }
}
