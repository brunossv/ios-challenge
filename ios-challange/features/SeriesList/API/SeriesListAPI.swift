//
//  
//  SeriesListAPI.swift
//  ios-challange
//
//  Created by Bruno Soares on 14/01/25.
//
//


import Foundation

protocol HandlerResponse { }

extension HandlerResponse {
    
    static func handler<T: Decodable>(_ model: T?,_ error: Error) -> Result<T?, Error> {
        if let model = model {
            return .success(model)
        }
        return .failure(error)
    }

}

class SeriesListAPI: HandlerResponse {
    struct Resources {
        static var url: String { get { Services.baseUrl + "/shows?page=1" } }
    }
    
    struct DataError: Error, LocalizedError {
        var errorDescription: String? {
            return "No Data"
        }
    }
    
    func get(_ handler: @escaping (Result<[SeriesListModel]?, Error>) -> Void) {
        let api = Services()
        
        api.request(Resources.url) { (model: [SeriesListModel]?, error) in
            handler(SeriesListAPI.handler(model, SeriesListAPI.DataError()))
        }
    }
}
