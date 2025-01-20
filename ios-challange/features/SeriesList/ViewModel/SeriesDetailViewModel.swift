//
//  
//  SeriesDetailViewModel.swift
//  ios-challange
//
//  Created by Bruno Soares on 16/01/25.
//
//

import Foundation

class SeriesDetailViewModel {
    
    enum Sections: Int, CaseIterable {
        case info = 0
        case cast
        case seasons
    }
    
    let api = SeriesListAPI()
    var seriesModel: SeriesListModel?
    
    init(seriesModel: SeriesListModel) {
        self.seriesModel = seriesModel
    }
    
    func requestSeasons(_ completion: @escaping (_ error: String?) -> Void) {
        
        guard let seriesID = self.seriesModel?.id else {
            completion("")
            return
        }
        
        self.api.getSeasons(show: seriesID) { [weak self] result in
            switch result {
            case .success(let model):
                self?.seriesModel?.seasons = model
                completion(nil)
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    func requestEpisodes(seasonID: Int,_ completion: @escaping (_ error: String?) -> Void) {
        self.api.getEpisodes(season: seasonID) { [weak self] result in
            switch result {
            case .success(let model):
                if let index = self?.seriesModel?.seasons?.firstIndex(where: { $0.id == seasonID }) {
                    self?.seriesModel?.seasons?[index].episodes = model
                }
                completion(nil)
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    func requestEpisodes(_ completion: @escaping (_ error: String?) -> Void) {
        
        guard let seasons = self.seriesModel?.seasons else {
            completion("")
            return
        }
        
        DispatchQueue.global().async(execute: .init(block: {
            let dispatchGroup = DispatchGroup()
            var errorMsg: String?
            
            for i in 0..<seasons.count {
                guard (self.seriesModel?.seasons?[i].episodes?.count ?? 0) == 0 else {
                    continue
                }
                
                dispatchGroup.enter()
                self.api.getEpisodes(season: seasons[i].id ?? 0) { [weak self] result in
                    switch result {
                    case .success(let model):
                        self?.seriesModel?.seasons?[i].episodes = model
                    case .failure(let error):
                        errorMsg = error.localizedDescription
                    }
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                completion(errorMsg)
            }
        }))
    }
    
    func requestCasters(_ completion: @escaping (_ error: String?) -> Void) {
        guard let seriesID = self.seriesModel?.id else {
            completion("")
            return
        }
        
        self.api.getCasters(show: seriesID) { [weak self] result in
            switch result {
            case .success(let model):
                self?.seriesModel?.casters = model
                completion(nil)
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    func requestSeriesInfo(_ completion: @escaping (_ error: String?) -> Void) {
        
        DispatchQueue.global().async(execute: {
            let dispatch = DispatchGroup()
            var errorMsg: String?
            
            dispatch.enter()
            self.requestSeasons { error in
                errorMsg = error
                dispatch.leave()
            }
            
            dispatch.enter()
            self.requestCasters() { error in
                errorMsg = error
                dispatch.leave()
            }
            
            dispatch.notify(queue: .main) {
                completion(errorMsg)
            }
        })
    }
    
    func saveSeriesFavorites(_ completion: @escaping (String?) -> Void) {
        self.requestEpisodes { [weak self] error in
            guard let model = self?.seriesModel else { return }
            FavoriteSeriesModel().saveSeries(model)
            completion(error)
        }
    }
    
    func seriesSaved() -> Bool {
        guard let name = self.seriesModel?.name else { return false }
        
        return FavoriteSeriesModel().alreadyFavorite(name: name)
    }
    
    func deleteSeriesSaved() {
        guard let name = self.seriesModel?.name else { return }
        FavoriteSeriesModel().deleteFavorite(named: name)
    }
}
