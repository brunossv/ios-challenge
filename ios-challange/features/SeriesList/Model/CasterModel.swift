//
//  CasterModel.swift
//  ios-challange
//
//  Created by Bruno Soares on 17/01/25.
//

struct CasterModel: Codable {
    var person: Person?
    var character: Character?
    
    struct Image: Codable {
        var medium: String?
        var original: String?
    }
    
    struct Person: Codable {
        var id: Int?
        var name: String?
        var image: Image?
    }
    
    struct Character: Codable {
        var id: Int?
        var name: String?
        var image: Image?
    }
}
