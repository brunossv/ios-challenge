//
//  SeriesTests.swift
//  ios-challangeTests
//
//  Created by Bruno Soares on 14/01/25.
//

import Testing
@testable import ios_challange
import Foundation

struct SeriesTests {
    
    let seriesViewModel = SeriesListViewModel()
    let favoriteViewModel = FavoriteSeriesListViewModel()

    @Test("Testing the list, pagination, search, and saving favorites")
    func testingAll() async throws {
        try await firstDataResponse()
        try await paginationDataResponse()
        try await savingSeriesDataResponse()
        try await favoritesDataResponse()
        try await deleteFavoritesDataResponse()
    }
    
    func firstDataResponse() async throws {
        return await withCheckedContinuation { continuation in
            seriesViewModel.request { error in
                #expect(error == nil, "firstDataResponse - Should be nil")
                var result: Int = 0
                seriesViewModel.model?.forEach({ result += $0.count })
                
                #expect(result > 0, "firstDataResponse - Should have more than 0 results")
                
                continuation.resume()
            }
        }
    }

    func paginationDataResponse() async throws {
        return await withCheckedContinuation { continuation in
            seriesViewModel.getNextPage {
                var result: Int = 0
                seriesViewModel.model?.forEach({ result += $0.count })
                #expect(result > 0, "paginationDataResponse - Should have more than 0 results")
                continuation.resume()
            }
        }
    }
    
    func searchBreakingBadDataResponse() async throws -> SeriesListModel? {
        return await withCheckedContinuation { continuation in
            seriesViewModel.searchShow(by: "Breaking bad") { error in
                #expect(error == nil, "searchByNameDataResponse - Should be nil")
                
                let result = seriesViewModel.model?.first?.first
                #expect(result?.name?.lowercased() == "breaking bad")
                
                continuation.resume(with: .success(result))
            }
        }
    }
    
    func savingSeriesDataResponse() async throws {
        guard let firstModel = try await self.searchBreakingBadDataResponse() else {
            throw CancellationError()
        }
        
        return await withCheckedContinuation { continuation in
            let detailSeriesViewModel = SeriesDetailViewModel(seriesModel: firstModel)
            detailSeriesViewModel.saveSeriesFavorites({ error in
                #expect(detailSeriesViewModel.seriesSaved(), "Series not saved")
                
                continuation.resume()
            })
        }
    }
    
//    let seasons = detailSeriesViewModel.seriesModel?.seasons?.count ?? 0
//    #expect(seasons > 0, "Failured to get seasons")
//    
//    let cast = detailSeriesViewModel.seriesModel?.cast?.count ?? 0
//    #expect(cast > 0, "Failed to get cast")
    
    func favoritesDataResponse() async throws {
        return await withCheckedContinuation { continuation in
            favoriteViewModel.request { error in
                #expect(error == nil, "favoritesDataResponse - Should be nil")
                var result: Int = 0
                favoriteViewModel.model?.forEach({ result += $0.count })
                #expect(result > 0)
                
                guard let firstModel = favoriteViewModel.model?.first?.first else {
                    fatalError()
                }
                
                let detailSeriesViewModel = SeriesDetailViewModel(seriesModel: firstModel)
                detailSeriesViewModel.deleteSeriesSaved()
                
                continuation.resume()
            }
        }
    }
    
    func deleteFavoritesDataResponse() async throws {
        return await withCheckedContinuation { continuation in
            favoriteViewModel.request { error in
                #expect(error == nil, "favoritesDataResponse - Should be nil")
                var result: Int = 0
                favoriteViewModel.model?.forEach({ result += $0.count })
                #expect(result == 0)
                
                continuation.resume()
            }
        }
    }
}
