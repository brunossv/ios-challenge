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
    var id: Int?
    var name: String?
    var image: Poster?
    var schedule: Schedule?
    var genres: [String]?
    var summary: String?
    var type: String?
    
    struct Poster: Codable {
        var medium: String?
        var original: String?
    }
    
    struct Schedule: Codable {
        var time: String?
        var days: [String]?
    }
    
    enum Genres: String, CaseIterable {
        case action = "Action"
        case drama = "Drama"
        case fantasy = "Fantasy"
        case scienceFiction = "Science-Fiction"
    }
}

extension Array where Element == SeriesListModel {
    
    func groupedByGenres() -> [[SeriesListModel]] {
        let filtered = self.sorted(by: { $0.genres == $1.genres } )
        let grouped = Dictionary(grouping: filtered) { value in
            return value.genres?.first ?? value.type ?? ""
        }
        var groupedArray: [[SeriesListModel]] = []
        grouped.forEach { array in
            groupedArray.append(array.value)
        }
        
        return groupedArray
    }
}
