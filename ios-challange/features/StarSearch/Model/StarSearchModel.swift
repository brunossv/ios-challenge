//
//  
//  StarSearchModel.swift
//  ios-challange
//
//  Created by Bruno Soares on 20/01/25.
//
//

import Foundation

struct StarSearchModel: Codable {
    var id: Int?
    var name: String?
    var image: Poster?
    
    var _embedded: Embedded?
    
    struct Poster: Codable {
        var medium: String?
        var original: String?
    }
    
    struct Embedded: Codable {
        var castcredits: [CastCredits]?
    }
    
    struct CastCredits: Codable {
        var _links: Links?
    }
    
    struct Links: Codable {
        var show: Show?
        var character: Character?
    }
    
    struct Show: Codable {
        var href: String?
        var name: String?
    }
    
    struct Character: Codable {
        var href: String?
        var name: String?
    }
    
    struct Series: Codable {
        var id: Int?
        var name: String?
        var image: Poster?
    }
}
