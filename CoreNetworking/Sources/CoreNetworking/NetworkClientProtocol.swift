//
//  NetworkClientProtocol.swift
//  CoreNetworking
//
//  Created by Karthik Ale on 8/2/26.
//

import Foundation

public protocol NetworkClientProtocol: Sendable {
    func request<T: Decodable>(endpoint: Endpoint) async throws -> T
    
}
