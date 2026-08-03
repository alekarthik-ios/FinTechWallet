//
//  NetworkClient.swift
//  CoreNetworking
//
//  Created by karthik Ale on 7/26/26.
//

import Foundation

public struct NetworkClient: NetworkClientProtocol {
    var baseURL: String
    
    public init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    public func request<T: Decodable> (endpoint:Endpoint ) async throws-> T {
        
        guard let url = URL(string: baseURL + endpoint.path) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = endpoint.method
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = endpoint.body {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let result = try JSONDecoder().decode(T.self, from: data)
        
        return result
        
    }
}
