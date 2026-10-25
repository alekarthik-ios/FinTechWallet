//
//  DeepLink.swift
//  walletApp
//
//  Created by Karthik Ale on 10/4/26.
//

enum DeepLink: Equatable {
    case wallet
    case sendMoney(recipientId: String?, amount: Double?)
}
