//
//  FavoriteSeriesListViewModel.swift
//  ios-challange
//
//  Created by Bruno Soares on 15/01/25.
//

class FavoriteSeriesListViewModel: SeriesListViewModelProtocol {
    var model: [[SeriesListModel]]?
    
    var allowPagination: Bool = false
    
    func request(_ completion: @escaping (String?) -> Void) {
        let favoriteModel = FavoriteSeriesModel()
        let favoritesArray = favoriteModel.listingAllFavorites().mapToSeriesListModel()
        self.model = [favoritesArray]
    }
    
    func searchShow(by name: String, _ completion: @escaping (String?) -> Void) {
        
    }
}
