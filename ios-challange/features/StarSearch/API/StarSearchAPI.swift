//
//  
//  StarSearchAPI.swift
//  ios-challange
//
//  Created by Bruno Soares on 20/01/25.
//
//


import Foundation

class StarSearchAPI: HandlerResponse {
    struct Resources {
        static var url: String { get { Services.baseUrl } }
        static var searchActor: String { get { Services.baseUrl + "/people?page=" } }
        static var actorDetail: (Int) -> String = { number in Services.baseUrl + "/people/\(number)?embed=castcredits" }
        static var searchActorByName: String { get { Services.baseUrl + "/search/people?q=" } }
    }
    
    struct DataError: Error, LocalizedError {
        var errorDescription: String? {
            return NSLocalizedString("error-localized-info", comment: "")
        }
    }
    
    func getStars(page: Int,_ handler: @escaping (Result<[StarSearchModel]?, Error>) -> Void) {
        let api = Services()
        
        api.request(Resources.searchActor + "\(page)") { (model: [StarSearchModel]?, error) in
            handler(SeriesListAPI.handler(model, SeriesListAPI.DataError()))
        }
    }
    
    func getPersonDetail(id: Int,_ handler: @escaping (Result<StarSearchModel?, Error>) -> Void) {
        let api = Services()
        
        api.request(Resources.actorDetail(id)) { (model: StarSearchModel?, error) in
            handler(SeriesListAPI.handler(model, SeriesListAPI.DataError()))
        }
    }
    
    func getSeriesInfo(url: String,_ handler: @escaping (Result<SeriesListModel?, Error>) -> Void) {
        let api = Services()
        
        api.request(url) { (model: SeriesListModel?, error) in
            handler(SeriesListAPI.handler(model, SeriesListAPI.DataError()))
        }
    }
    
    func getStars(by name: String,_ handler: @escaping (Result<[StarSearchModel]?, Error>) -> Void) {
        let api = Services()
        
        api.request(Resources.searchActorByName + name) { (model: [StarSearchNamedModel]?, error) in
            handler(SeriesListAPI.handler(model?.map({$0.person ?? .init() }), SeriesListAPI.DataError()))
        }
    }
}
