//
//  
//  SeriesListAPI.swift
//  ios-challange
//
//  Created by Bruno Soares on 14/01/25.
//
//


import Foundation

class SeriesListAPI: HandlerResponse {
    struct Resources {
        static var url: String { get { Services.baseUrl + "/path" } }
    }
    
    struct DataError: Error, LocalizedError {
        var errorDescription: String? {
            return NSLocalizedString("error-localized-info", comment: "")
        }
    }
    
    func get(_ handler: @escaping (Result<Array<SeriesListModel>?, Error>) -> Void) {
        let api = Services()
        
        api.request(Resources.url) { (model: Default<Array<SeriesListModel>>?, error) in
            handler(SeriesListAPI.handler(model, [.cantFinish:SeriesListAPI.DataError()]))
        }
    }
}
