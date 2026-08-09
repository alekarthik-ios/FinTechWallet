//
//  File.swift
//  FeatureLogin
//
//  Created by Karthik Ale on 8/4/26.
//

import Foundation
import SwiftUI

@MainActor
public struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    
    public init(viewModel: LoginViewModel) {
        self.viewModel = viewModel  
    }
    
    public var body: some View {
        
            ZStack {
                LinearGradient(colors: [Color.purple, Color.blue],
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
    
                
                VStack(spacing: 8) {
                    
                    Image(systemName: "creditcard.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.white)
                    
                    Text("WalletApp")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        
                    Text("Welcome back")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.75))
                    
                    
                    TextField("Email", text: $viewModel.email)    //binding
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .cornerRadius(12)
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .cornerRadius(12)

                    
                    Button {
                           Task {   // wrap in task swift 6 concurrency
                               await viewModel.login()
                            }
                        }label: {
                            Text("Login")
                                .fontWeight(.semibold)
                                .foregroundColor(Color.blue)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                    
                    
                    if viewModel.isLoading {
                        ProgressView()
                    }
                    
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                    }
                    
                }
                .navigationBarTitle("Login")
                .padding(.bottom, 40)
                
        }
    }
            
        
}
    

