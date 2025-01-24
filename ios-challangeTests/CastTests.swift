//
//  CastTests.swift
//  ios-challange
//
//  Created by Bruno Soares on 23/01/25.
//

import Testing
@testable import ios_challange
import Foundation

struct CastTests {
    let viewModel = StarSearchViewModel()
    
    @Test("Testing cast data")
    func testingAll() async throws {
        try await gettingFirstData()
        try await gettingNextPage()
        try await findStarByName()
    }
    
    func gettingFirstData() async throws {
        return await withCheckedContinuation { continuation in
            viewModel.getData { error in
                #expect(error == nil, "Should be not error")
                
                #expect(viewModel.model?.count ?? 0 > 0, "Should have at least one star")
                continuation.resume()
            }
        }
    }
    
    func gettingNextPage() async throws {
        return await withCheckedContinuation { continuation in
            viewModel.getNextPage { error in
                #expect(error == nil, "Should be not error")
                
                #expect(viewModel.model?.count ?? 0 > 0, "Should have at least one star")
                continuation.resume()
            }
        }
    }
    
    func findStarByName() async throws {
        return await withCheckedContinuation { continuation in
            viewModel.request(by: "Dean Norris") { error in
                #expect(error == nil, "Should be not error")
                
                #expect(viewModel.model?.count ?? 0 > 0, "Should have at least one star")
                continuation.resume()
            }
        }
    }
}
