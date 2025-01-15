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
    
    func request(_ completion: @escaping (_ error: String?) -> Void) {
        self.api.get { result in
            switch result {
            case .success(let model):
                self.model = model?.groupedByGenres()
                completion(nil)
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    func getNextPage(_ completion: @escaping () -> Void) {
        let nextPage = ((self.model?.last?.last?.id ?? 0) / 250) + 1
        self.api.getNext(page: nextPage) { result in
            switch result {
            case .success(let model):
                self.model?.append(contentsOf: model?.groupedByGenres() ?? [])
                completion()
            case .failure(let error):
                completion()
            }
        }
    }
}
