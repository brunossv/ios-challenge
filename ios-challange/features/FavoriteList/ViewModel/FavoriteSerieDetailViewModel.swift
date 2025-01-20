//
//  FavoriteSerieDetailViewModel.swift
//  ios-challange
//
//  Created by Bruno Soares on 20/01/25.
//

class FavoriteSerieDetailViewModel: SeriesDetailViewModel {
    override func requestCasters(_ completion: @escaping (String?) -> Void) {
        completion(nil)
    }
    
    override func requestSeasons(_ completion: @escaping (String?) -> Void) {
        completion(nil)
    }
    
    override func requestEpisodes(_ completion: @escaping (String?) -> Void) {
        completion(nil)
    }
    
    override func requestEpisodes(seasonID: Int, _ completion: @escaping (String?) -> Void) {
        completion(nil)
    }
    
    override func requestSeriesInfo(_ completion: @escaping (String?) -> Void) {
        completion(nil)
    }
}
