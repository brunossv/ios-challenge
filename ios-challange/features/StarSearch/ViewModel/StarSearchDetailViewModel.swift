//
//  
//  StarSearchDetailViewModel.swift
//  ios-challange
//
//  Created by Bruno Soares on 21/01/25.
//
//

import Foundation

class StarSearchDetailViewModel {
    
    enum Sections: Int, CaseIterable {
        case actor
        case shows
    }
    
    let api = StarSearchAPI()
    var model: StarSearchModel
    
    init(model: StarSearchModel) {
        self.model = model
    }
    
    func request(_ completion: @escaping (_ error: String?) -> Void) {
        guard let modelID = self.model.id else {
            completion("")
            return
        }
        self.api.getPersonDetail(id: modelID) { result in
            switch result {
            case .success(let model):
                self.model._embedded = model?._embedded
                completion(nil)
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    func getSeriesInfo(url: String, _ completion: @escaping (_ url: String?) -> Void) {
        
        self.api.getSeriesInfo(url: url) { result in
            switch result {
            case .success(let model):
                completion(model?.url)
            case .failure(let error):
                completion(nil)
            }
        }
    }
}
