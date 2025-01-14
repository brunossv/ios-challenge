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
    var model: [SeriesListModel]?
    
    func request(_ completion: @escaping (_ error: String?) -> Void) {
        self.api.get { result in
            switch result {
            case .success(let model):
                self.model = model
                completion(nil)
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
}
