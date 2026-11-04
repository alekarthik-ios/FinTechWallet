//
//  DeeplinkParser.swift
//  walletApp
//
//  Created by Karthik Ale on 11/3/26.
//

import Foundation

enum DeepLinkParser {
    nonisolated static func parse(_ url: URL) -> DeepLink? {
        guard url.scheme == "fintechwallet" else { return nil }
        
        switch url.host {
          case "wallet": return .wallet
          case "send":
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            let recipient = components?.queryItems?.first(where: { $0.name == "recipient" })?.value
            let amountText = components?.queryItems?.first(where: { $0.name == "amount" })?.value
            
            var amount: Decimal? = nil
            if let text = amountText,
               let value = Decimal(string: text),
               value > 0 {
                  amount = value
               }
            return .sendMoney(recipientId: recipient, amount: amount)
            
            default : return nil
        }
        
    }
}

