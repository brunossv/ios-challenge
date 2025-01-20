//
//  FavoriteSeriesModel.swift
//  ios-challange
//
//  Created by Bruno Soares on 15/01/25.
//
import CoreData

struct FavoriteSeriesModel {
    private var context: NSManagedObjectContext
    
    init() {
        let container = NSPersistentContainer(name: "ios_challange")
        container.loadPersistentStores { _, _ in }
        self.context = container.viewContext
    }
    
    func saveSeries(_ series: SeriesListModel) {
        func entity<T: NSManagedObject>(named: String) -> T {
            if let object = NSEntityDescription.insertNewObject(forEntityName: named, into: self.context) as? T {
                return object
            }
            return T()
        }
        let serieObject: Series = entity(named: "Series")
        serieObject.name = series.name
        serieObject.poster = series.image?.medium
        serieObject.genres = series.genres?.transformToStringSeparedByComma()
        serieObject.summary = series.summary
        serieObject.days = series.schedule?.days?.transformToStringSeparedByComma()
        serieObject.time = series.schedule?.time
        
        series.cast?.forEach({ cast in
            let castObject: Cast = entity(named: "Casters")
            castObject.actorName = cast.person?.name
            castObject.characterName = cast.character?.name
            castObject.image = cast.person?.image?.medium ?? cast.person?.image?.original
            
            serieObject.addToCast(castObject)
        })
        series.seasons?.forEach({ seasonModel in
            let seasonObject: Seasons = entity(named: "Seasons")
            seasonObject.number = Int16(seasonModel.number ?? 0)
            
            seasonModel.episodes?.forEach({ episodeModel in
                let episodesObject: Episodes = entity(named: "Episodes")
                episodesObject.name = episodeModel.name
                episodesObject.summary = episodeModel.summary
                episodesObject.number = Int16(episodeModel.number ?? 0)
                episodesObject.season = Int16(episodeModel.season ?? 0)
                episodesObject.image = episodeModel.image?.original ?? episodeModel.image?.medium
                
                seasonObject.addToEpisodes(episodesObject)
            })
            serieObject.addToSeasons(seasonObject)
        })
        
        do {
            try self.context.save()
        } catch {
            print(error)
        }
    }
    
    func listingAllFavorites() -> [Series] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Series")
        
        if let favorites = try? self.context.fetch(fetchRequest) as? [Series] {
            
            return favorites
        }
        
        return []
    }
    
    func alreadyFavorite(name: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Series")
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        if let favorites = try? self.context.fetch(fetchRequest), favorites.count > 0 {
            return true
        }
        return false
    }
    
    func deleteFavorite(named: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Series")
        fetchRequest.predicate = NSPredicate(format: "name == %@", named)
        if let favorites = try? self.context.fetch(fetchRequest) as? [NSManagedObject] {
            for favorite in favorites {
                self.context.delete(favorite)
            }
            try? self.context.save()
        }
    }
}

extension Array where Element: Series {
    func mapToSeriesListModel() -> [SeriesListModel] {
        let result = self.map({ series in
            var model = SeriesListModel()
            model.genres = series.genres?.transformStringSeparatedByCommaToArray()
            model.image = SeriesListModel.Poster(medium: series.poster)
            model.name = series.name
            model.schedule = SeriesListModel.Schedule(time: series.time, days: series.days?.transformStringSeparatedByCommaToArray())
            model.summary = series.summary
            model.seasons = (series.seasons?.allObjects as? [Seasons])?.mapToSeasonModel()
            model.seasons = model.seasons?.sorted(by: { $0.number ?? 0 < $1.number ?? 0 })
            model.cast = (series.cast?.allObjects as? [Cast])?.mapToCasterModel()
            
            return model
        })
        
        return result
    }
}

//This is necessary until Xcode has an error with Transformable custom types.
fileprivate extension Array {
    func transformToStringSeparedByComma() -> String {
        var stringResult: String = ""
        for item in self {
            stringResult += "\(item)-"
        }
        
        stringResult.removeLast()
        
        return stringResult
    }
}

fileprivate extension String {
    func transformStringSeparatedByCommaToArray() -> [String] {
        return self.split(separator: "-").map(String.init)
    }
}
