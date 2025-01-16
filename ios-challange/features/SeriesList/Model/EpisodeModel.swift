//
//  EpisodeModel.swift
//  ios-challange
//
//  Created by Bruno Soares on 15/01/25.
//

struct EpisodeModel: Codable {
    var name: String?
    var summary: String?
    var episode: Int?
    var image: String?
}

extension Array where Element: Episodes {
    func mapToEpisodeModel() -> [EpisodeModel] {
        let result = self.map({ seasons in
            var model = EpisodeModel()
            model.name = seasons.name
            model.name = seasons.name
            model.summary = seasons.summary
            model.episode = Int(seasons.number)
            model.image = seasons.image
            
            return model
        })
        
        return result
    }
}
