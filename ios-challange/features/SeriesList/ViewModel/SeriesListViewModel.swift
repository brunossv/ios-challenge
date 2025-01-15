//
//  
//  SeriesListViewModel.swift
//  ios-challange
//
//  Created by Bruno Soares on 14/01/25.
//
//

import Foundation

class SeriesListViewModel {
    let api = SeriesListAPI()
    var model: [[SeriesListModel]]?
    var allowPagination: Bool = true
    
    func request(_ completion: @escaping (_ error: String?) -> Void) {
        self.api.get { [weak self] result in
            switch result {
            case .success(let model):
                self?.model = model?.groupedByGenres()
                self?.allowPagination = true
                completion(nil)
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    func getNextPage(_ completion: @escaping () -> Void) {
        let nextPage = ((self.model?.last?.last?.id ?? 0) / 250) + 1
        self.api.getNext(page: nextPage) { [weak self] result in
            switch result {
            case .success(let model):
                self?.model?.append(contentsOf: model?.groupedByGenres() ?? [])
                completion()
            case .failure(_):
                completion()
            }
        }
    }
    
    func searchShow(by name: String, _ completion: @escaping (_ error: String?) -> Void) {
        self.allowPagination = false
        self.api.getShowBy(name: name) { [weak self] result in
            switch result {
            case .success(let model):
                self?.model = [model!.map({ $0.show! })]
                completion(nil)
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
}
