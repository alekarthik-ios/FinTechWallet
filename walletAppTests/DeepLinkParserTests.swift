//
//  DeepLinkParserTests.swift
//  walletAppTests
//
//  Created by Karthik Ale on 11/3/26.
//

import XCTest
@testable import walletApp


final class DeepLinkParserTests: XCTestCase {
    
    func test_walletHost_returnsWallet(){
        
        let url = URL(string: "fintechwallet://wallet")!
        let result = DeepLinkParser.parse(url)
        
        XCTAssertEqual(result, .wallet)
    }
    
    func test_sendWithValidValues_returnsPrefilledSend(){
        let url = URL(string: "fintechwallet://send?recipient=pop&amount=100")!
        let result = DeepLinkParser.parse(url)
        
        XCTAssertEqual(result, .sendMoney(recipientId: "pop", amount: 100))
    }
    
    func test_wrongScheme_returnsNil(){
        let url = URL(string: "https://wallet.com")!
        let result = DeepLinkParser.parse(url)
        
        XCTAssertNil(result)
    }
    
    func test_unknownHost_returnsNil(){
        let url = URL(string: "fintechwallet://unknown")!
        let result = DeepLinkParser.parse(url)
        
        XCTAssertNil(result)
    }
    
    func test_invalidAmount_keepsRecipientDropsAmount(){
        let url = URL(string: "fintechwallet://send?recipient=pop&amount=notanumber")!
        let result = DeepLinkParser.parse(url)
        
        XCTAssertEqual(result, .sendMoney(recipientId: "pop", amount: nil))
    }
    
    func test_negativeAmount_keepsRecipientDropsAmount(){
        let url = URL(string: "fintechwallet://send?recipient=pop&amount=-100")!
        let result = DeepLinkParser.parse(url)
        
        XCTAssertEqual(result, .sendMoney(recipientId: "pop", amount: nil))
    }
}

        
