//
//  WalletView.swift
//  FeatureWallet
//
//  Created by Karthik Ale on 8/8/26.
//

import SwiftUI

@MainActor
public struct WalletView: View {

    
    @ObservedObject var viewModel: WalletViewModel
        
    public init(viewModel: WalletViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .topLeading,
                           endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            
            VStack(spacing: 10) {
                Text(viewModel.balance)
                    .font(.largeTitle)
                    .foregroundStyle(Color(.white))
                    .padding(10)
                
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                }
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                }
                
                
                
            }
            .task {
                await viewModel.fetchBalance()
            }
        }
    }
        
            
   
    
}
