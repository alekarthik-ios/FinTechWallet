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
        
        switch viewModel.state {
        case .idle:
            Color.clear
                .task { await viewModel.fetchBalance() }
            
        case .loading:
            ZStack {
                gradient
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
            }
            
        case .loaded(let balance, let transactions):
            ZStack {
                gradient
                
                VStack(spacing: 24) {
                    Spacer()
                    
                    Text("Welcome, Karthik")
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text(balance)
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("USD")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                        .textCase(.uppercase)
                    
                    Spacer()
                    
                    HStack(spacing: 32) {
                        actionButton(icon: "arrow.up.circle.fill", label: "Send") {
                            viewModel.onSendMoneyTapped?()
                        }
                        actionButton(icon: "plus.circle.fill", label: "Add") {}
                        actionButton(icon: "arrow.down.circle.fill", label: "Request") {}
                    }
                    .padding(.bottom, 16)
                    
                    if !transactions.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Recent Activity")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            ForEach(transactions, id: \.id) { transaction in
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
                    
                    Spacer()
                }
                .padding()
            }
            
        case .error(let message):
            ZStack {
                gradient
                Text(message)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }
        }
    }
    
    // MARK: - Gradient
    private var gradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [.blue, .purple, .pink]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
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
