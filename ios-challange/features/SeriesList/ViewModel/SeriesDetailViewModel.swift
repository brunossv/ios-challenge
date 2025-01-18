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
    var model: [SeasonModel]?
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
                self?.model = model
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
                if let index = self?.model?.firstIndex(where: { $0.id == seasonID }) {
                    self?.model?[index].episodes = model
                    self?.seriesModel?.seasons?[index].episodes = model
                }
                completion(nil)
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    func requestEpisodes(_ completion: @escaping (_ error: String?) -> Void) {
        
        guard let seasons = self.model else {
            completion("")
            return
        }
        
        let dispatchGroup = DispatchGroup()
        var errorMsg: String?
        DispatchQueue.global().async(execute: .init(block: {
            for i in 0..<seasons.count {
                dispatchGroup.enter()
                self.api.getEpisodes(season: seasons[i].id ?? 0) { [weak self] result in
                    switch result {
                    case .success(let model):
                        self?.model?[i].episodes = model
                        completion(nil)
                    case .failure(let error):
                        errorMsg = error.localizedDescription
                    }
                    dispatchGroup.leave()
                }
            }
            self.seriesModel?.seasons = self.model
        }))
        
        dispatchGroup.notify(queue: .main) {
            completion(errorMsg)
        }
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
        let semaphore = DispatchSemaphore(value: 1)
        
        DispatchQueue.global().async(execute: .init(block: {
            var errorMsg: String?
            semaphore.wait()
            self.requestSeasons { error in
                errorMsg = error
                semaphore.signal()
            }
            
            semaphore.wait()
            self.requestEpisodes() { error in
                errorMsg = error
                semaphore.signal()
            }
            
            DispatchQueue.main.async {
                completion(errorMsg)
            }
        }))
    }
}
