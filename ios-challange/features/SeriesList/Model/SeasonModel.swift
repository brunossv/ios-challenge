//
//  SeasonModel.swift
//  ios-challange
//
//  Created by Bruno Soares on 15/01/25.
//

struct SeasonModel: Codable {
    var id: Int?
    var name: String?
    var number: Int?
    var episodes: [EpisodeModel]?
}

extension Array where Element: Seasons {
    func mapToSeasonModel() -> [SeasonModel] {
        let result = self.map({ seasons in
            var model = SeasonModel()
            model.name = seasons.name
            model.episodes = (seasons.episodes?.allObjects as? [Episodes])?.mapToEpisodeModel()
            
            return model
        })
        
        return result
    }
}
