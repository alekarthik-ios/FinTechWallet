//
//  WalletView.swift
//  FeatureWallet
//
//  Created by Karthik Ale on 8/8/26.
//

import SwiftUI
import SharedModels

@MainActor
public struct WalletView: View {
    
    @ObservedObject var viewModel: WalletViewModel
    
    public init(viewModel: WalletViewModel) {
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
                Spacer()
                
                // Greeting
                Text("Welcome, Karthik")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.8))
                
                // Balance
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                } else {
                    Text(viewModel.balance)
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                }
                
                Text("USD")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
                    .textCase(.uppercase)
                    
                
                Spacer()
                
                // Action Buttons
                HStack(spacing: 32) {
                    actionButton(icon: "arrow.up.circle.fill", label: "Send"){
                        viewModel.onSendMoneyTapped?()
                    }
                    actionButton(icon: "plus.circle.fill", label: "Add"){}
                    actionButton(icon: "arrow.down.circle.fill", label: "Request"){}
                }
                .padding(.bottom, 16)
                
                // Recent Activity
                if !viewModel.transactions.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recent Activity")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        ForEach(viewModel.transactions, id: \.id) { transaction in
                            HStack {
                                Image(systemName: transaction.amount > 0 ? "arrow.down.circle.fill" : "arrow.up.circle.fill")
                                    .foregroundColor(.white)
                                
                                Text(transaction.recipient)
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Text(String(format: "$%.2f", transaction.amount))
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                            }
                            .padding()
                            .background(.white.opacity(0.15))
                            .cornerRadius(12)
                        }
                    }
                    .padding(.top, 16)
                }
                
                // Error
                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
                
                Spacer()
            }
            .padding()
        }
        .task {
            await viewModel.fetchBalance()
        }
    }
    
    // MARK: - Action Button
    private func actionButton(icon: String, label: String, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 28))
                Text(label)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .foregroundColor(.purple)
            .frame(width: 80, height: 80)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.15), radius: 8, y: 4)
        }
    }
}
