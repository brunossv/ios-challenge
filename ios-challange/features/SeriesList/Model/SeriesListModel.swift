//
//  
//  SeriesListModel.swift
//  ios-challange
//
//  Created by Bruno Soares on 14/01/25.
//
//

import Foundation

struct SeriesListModel: Codable {
    var name: String?
    var image: Poster?
    var schedule: Schedule?
    var genres: [String]?
    var summary: String?
    
    struct Poster: Codable {
        var medium: String?
        var original: String?
    }
    
    struct Schedule: Codable {
        var time: String?
        var days: [String]?
    }
}
