//
//  File.swift
//  FeatureLogin
//
//  Created by Karthik Ale on 8/3/26.
//

import XCTest
@testable import FeatureLogin
import CoreNetworking
import SharedModels

enum TestError: Error{
    case somethingFailed
}

final class LoginUseCaseTests: XCTestCase {
    
    
    
    func test_login_returnsToken_whenNetworkSucceeds() async throws {
        
        let mock = MockNetworkClient()
        
        mock.resultToReturn = AuthToken (
            userId: "karthikale",
            accessToken: "12345",
            expiryDate: Date()
        )
        
        
        let repository = LoginRepository(networking: mock)
        
        let useCase = LoginUseCase(repository: repository)
        
        do{
            let result = try await useCase.execute(email: "karthikale@gmail.com", password: "password")
            
            XCTAssertEqual(result.userId, "karthikale")
        }catch{
            XCTFail("Expected to succeed but got error instead")
        
        }
    }
    

    func test_login_throwsError_whenNetworkFails() async throws {
        
        let mock = MockNetworkClient()
        
        mock.errorToReturn = TestError.somethingFailed
        
        let repository = LoginRepository(networking: mock)
        
        let useCase = LoginUseCase(repository: repository)
    
    
        do{
            _ = try await useCase.execute(email: "karthikale@gmail.com", password: "password")
            XCTFail("Expected to throw error but got success instead")
        }catch{
            //threw as expected test passes, do nothing
        }
    }
    
}
