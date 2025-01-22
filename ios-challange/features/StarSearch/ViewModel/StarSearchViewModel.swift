//
//  
//  StarSearchViewModel.swift
//  ios-challange
//
//  Created by Bruno Soares on 20/01/25.
//
//

import Foundation

class StarSearchViewModel {
    let api = StarSearchAPI()
    var searchModel: [StarSearchModel]? = []
    var model: [StarSearchModel]? = []
    var allowPagination: Bool = true
    
    func getData(_ completion: @escaping (_ error: String?) -> Void) {
        self.api.getStars(page: 0) { [weak self] result in
            switch result {
            case .success(let model):
                self?.model?.append(contentsOf: model ?? [])
                self?.searchModel?.append(contentsOf: model ?? [])
                completion(nil)
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    func getNextPage(_ completion: @escaping (_ error: String?) -> Void) {
        let nextPage = ((self.model?.last?.id ?? 0) / 1000) + 1
        self.api.getStars(page: nextPage) { [weak self] result in
            switch result {
            case .success(let model):
                self?.model?.append(contentsOf: model ?? [])
                self?.searchModel?.append(contentsOf: model ?? [])
                completion(nil)
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    func request(by name: String, _ completion: @escaping (_ error: String?) -> Void) {
        self.allowPagination = false
        self.api.getStars(by: name) { [weak self] result in
            switch result {
            case .success(let model):
                self?.model = model
                completion(nil)
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    func endSearch() {
        self.allowPagination = true
        self.model = self.searchModel
    }
}
