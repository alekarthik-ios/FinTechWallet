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
    let sendMoneyUseCase: SendMoneyUseCaseProtocol
    
    public init(sendMoneyUseCase: SendMoneyUseCaseProtocol) {
        self.sendMoneyUseCase = sendMoneyUseCase
    }
    
    @Published public var amount: String = ""
    @Published public var recipientId: String = ""
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?
    @Published public var isSuccess: Bool = false
    public var onBackTapped: (() -> Void)?
    
    public func sendMoney() async {
        isLoading = true
        isSuccess = false
        errorMessage = nil
        
        guard let amountValue = Double(amount), amountValue > 0 else {
            errorMessage = "Please enter a valid amount"
            isLoading = false
            return
        }
        do {
            try await sendMoneyUseCase.execute(amount: amountValue, recipientId: recipientId)
            isSuccess = true
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
}
