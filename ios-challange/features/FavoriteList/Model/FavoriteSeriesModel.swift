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
        let entity: (String) -> NSManagedObject = { (name) in
            return NSEntityDescription.insertNewObject(forEntityName: name, into: self.context)
        }
        let seriesObject = entity("Series") as? Series
        seriesObject?.name = series.name
        seriesObject?.poster = series.image?.medium
        seriesObject?.genres = series.genres
        seriesObject?.summary = series.summary
        
        series.seasons?.forEach({ seasonModel in
            let seasonsObject = entity("Seasons") as? Seasons
            seasonsObject?.name = seasonModel.name
            seasonsObject?.series = seriesObject
            
            seasonModel.episodes?.forEach({ episodeModel in
                let episodesObject = entity("Episodes") as? Episodes
                episodesObject?.name = episodeModel.name
                episodesObject?.summary = episodeModel.summary
                episodesObject?.number = Int16(episodeModel.episode ?? 0)
                episodesObject?.image = episodeModel.image
                
                if let episode = episodesObject {
                    seasonsObject?.addToEpisodes(episode)
                }
            })
            
            if let seasons = seasonsObject {
                seriesObject?.addToSeasons(seasons)
            }
        })
        
        do {
            try self.context.save()
        } catch {
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
        
        if let favorites = try? self.context.fetch(fetchRequest), favorites.count > 1 {
            return true
        }
        return false
    }
}

extension Array where Element: Series {
    func mapToSeriesListModel() -> [SeriesListModel] {
        let result = self.map({ series in
            var model = SeriesListModel()
            model.genres = series.genres
            model.image = SeriesListModel.Poster(medium: series.poster)
            model.name = series.name
            model.schedule = SeriesListModel.Schedule(time: series.schedules?.time, days: series.schedules?.days)
            model.summary = series.summary
            model.seasons = (series.seasons?.allObjects as? [Seasons])?.mapToSeasonModel()
            
            return model
        })
        
        return result
    }
}
