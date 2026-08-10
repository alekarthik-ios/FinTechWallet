//
//  SendMoneyView.swift
//  FeatureSendMoney
//
//  Created by Karthik Ale on 8/9/26.
//

import SwiftUI

@MainActor
public struct SendMoneyView: View {
    @ObservedObject var viewModel: SendMoneyViewModel
    
    public init(viewModel: SendMoneyViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.blue, .purple, .pink]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 24) {
                
                HStack {
                    Button {
                        viewModel.onBackTapped?()
                    } label: {
                         Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(.white)
                      }
                    Spacer()
                }
                .padding(.top, 16)
                                
                Spacer()
                
                Text("Send Money")
                    .font(.title)
                    .foregroundColor(.white)
                
                TextField("Amount ($)", text: $viewModel.amount)
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(.white)
                    .cornerRadius(12)
                
                TextField("Recipient ID", text: $viewModel.recipientId)
                    .padding()
                    .background(.white)
                    .cornerRadius(12)
                
                Button {
                    Task { await viewModel.sendMoney() }
                } label: {
                    Text("Send")
                        .fontWeight(.bold)
                        .foregroundColor(.purple)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.white)
                        .cornerRadius(12)
                }
                
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                }
                
                if viewModel.isSuccess {
                    Text("Sent successfully!")
                        .font(.title3)
                        .foregroundColor(.green)
                }
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                }
                
                Spacer()
            }
            .padding(.horizontal, 32)
        }
    }
}
