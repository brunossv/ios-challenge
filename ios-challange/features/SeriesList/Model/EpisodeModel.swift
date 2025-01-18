//
//  EpisodeModel.swift
//  ios-challange
//
//  Created by Bruno Soares on 15/01/25.
//

struct EpisodeModel: Codable {
    var id: Int?
    var name: String?
    var number: Int?
    var season: Int?
    var summary: String?
    var image: Poster?
    
    struct Poster: Codable {
        var medium: String?
        var original: String?
    }
    
    init() {}
    
    init(from decoder: Decoder) {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        self.id = try? container?.decode(Int.self, forKey: .id)
        self.name = try? container?.decode(String.self, forKey: .name)
        self.number = try? container?.decode(Int.self, forKey: .number)
        self.season = try? container?.decode(Int.self, forKey: .season)
        self.summary = try? container?.decode(String.self, forKey: .summary)
        self.image = try? container?.decode(EpisodeModel.Poster.self, forKey: .image)
    }
}

extension Array where Element: Episodes {
    func mapToEpisodeModel() -> [EpisodeModel] {
        let result = self.map({ seasons in
            var model = EpisodeModel()
            model.name = seasons.name
            model.name = seasons.name
            model.summary = seasons.summary
            model.number = Int(seasons.number)
            model.season = Int(seasons.season)
            model.image = EpisodeModel.Poster(medium: seasons.image)
            
            return model
        })
        
        return result
    }
}
