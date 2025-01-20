//
//  CastModel.swift
//  ios-challange
//
//  Created by Bruno Soares on 17/01/25.
//

struct CastModel: Codable {
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

extension Array where Element: Cast {
    func mapToCasterModel() -> [CastModel] {
        let result = self.map({ caster in
            var model = CastModel()
            let image = CastModel.Image(medium: caster.image)
            model.person = CastModel.Person(name: caster.actorName, image: image)
            model.character = CastModel.Character(name: caster.characterName, image: image)
            
            return model
        })
        
        return result
    }
}
