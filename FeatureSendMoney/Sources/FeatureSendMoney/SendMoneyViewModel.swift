//
//  SendMoneyViewModel.swift
//  FeatureSendMoney
//
//  Created by Karthik Ale on 8/9/26.
//

import Foundation
import Combine

@MainActor
public final class SendMoneyViewModel: ObservableObject {
    
    public enum SendState {
        case idle
        case sending
        case success
        case failure(String)
    }
    
    let sendMoneyUseCase: SendMoneyUseCaseProtocol
    
    public init(sendMoneyUseCase: SendMoneyUseCaseProtocol) {
        self.sendMoneyUseCase = sendMoneyUseCase
    }
    
    @Published public var amount: String = ""
    @Published public var recipientId: String = ""
    @Published public var state: SendState = .idle
    public var onBackTapped: (() -> Void)?
    
    public func sendMoney() async {
        
        guard let amountValue = Double(amount), amountValue > 0 else {
            state = .failure("Please enter a valid amount")             //fires a rebuild
            return
        }
        
        self.state = .sending                   //fires a rebuild
        
        do {
            try await sendMoneyUseCase.execute(amount: amountValue, recipientId: recipientId)
            state = .success
        } catch {
            state = .failure(error.localizedDescription)
        }
        
    }
    
}
