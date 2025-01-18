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
        static var url: String { get { Services.baseUrl } }
        static var page: String { get { Services.baseUrl + "/shows?page=" } }
        static var searching: String { get { Services.baseUrl + "/search/shows?q=" } }
        static var seasons: (Int) -> String = { number in Services.baseUrl + "/shows/\(number)/seasons" }
        static var episodes: (Int) -> String = { number in Services.baseUrl + "/seasons/\(number)/episodes" }
        static var casters: (Int) -> String = { number in Services.baseUrl + "/shows/\(number)/cast" }
    }
    
    struct DataError: Error, LocalizedError {
        var errorDescription: String? {
            return "No Data"
        }
    }
    
    func get(_ handler: @escaping (Result<[SeriesListModel]?, Error>) -> Void) {
        let api = Services()
        
        api.request(Resources.page + "0") { (model: [SeriesListModel]?, error) in
            handler(SeriesListAPI.handler(model, SeriesListAPI.DataError()))
        }
    }
    
    func getNext(page: Int,_ handler: @escaping (Result<[SeriesListModel]?, Error>) -> Void) {
        let api = Services()
        
        api.request(Resources.page + "\(page)") { (model: [SeriesListModel]?, error) in
            handler(SeriesListAPI.handler(model, SeriesListAPI.DataError()))
        }
    }
    
    func getShowBy(name: String,_ handler: @escaping (Result<[ShowModel]?, Error>) -> Void) {
        let api = Services()
        
        api.request(Resources.searching + name) { (model: [ShowModel]?, error) in
            handler(SeriesListAPI.handler(model, SeriesListAPI.DataError()))
        }
    }
    
    func getSeasons(show: Int, _ handler: @escaping (Result<Array<SeasonModel>?, Error>) -> Void) {
        let api = Services()
        
        api.request(Resources.seasons(show)) { (model: [SeasonModel]?, error) in
            handler(SeriesListAPI.handler(model, SeriesListAPI.DataError()))
        }
    }
    
    func getEpisodes(season: Int, _ handler: @escaping (Result<Array<EpisodeModel>?, Error>) -> Void) {
        let api = Services()
        
        api.request(Resources.episodes(season)) { (model: Array<EpisodeModel>?, error) in
            handler(SeriesListAPI.handler(model, SeriesListAPI.DataError()))
        }
    }
    
    func getCasters(show: Int, _ handler: @escaping (Result<Array<CasterModel>?, Error>) -> Void) {
        let api = Services()
        
        api.request(Resources.casters(show)) { (model: [CasterModel]?, error) in
            handler(SeriesListAPI.handler(model, SeriesListAPI.DataError()))
        }
    }
}
