//
//  FavoriteSeriesCoordinator.swift
//  ios-challange
//
//  Created by Bruno Soares on 16/01/25.
//
import UIKit

class FavoriteSeriesCoordinator: Coordinator {
    
    weak var coordinator: Coordinator?
    
    var childCoordinator: [Coordinator]
    
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController? = nil) {
        self.childCoordinator = []
        self.navigationController = navigationController
    }
    
    func start() {
        let favoriteViewController = FavoriteSeriesController(viewModel: FavoriteSeriesListViewModel(), coordinator: self)
        favoriteViewController.title = MainCoordinator.Tabs.favorites.title
        self.navigationController?.pushViewController(favoriteViewController, animated: true)
    }
}

extension FavoriteSeriesCoordinator: SeriesListCoordinatorProtocol {
    func openSeriesDetail(model: SeriesListModel) {
        let viewModel = FavoriteSerieDetailViewModel(seriesModel: model)
        let viewController = FavoriteSerieDetailViewController(viewModel: viewModel, coordinator: self)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func openEpisodeList(model: [EpisodeModel]) {
        let viewModel = EpisodesListViewModel(model: model)
        let viewController = EpisodesListViewController(viewModel: viewModel, coordinator: self)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func openEpisodeDetail(model: EpisodeModel) {
        let viewModel = EpisodeDetailViewModel(model: model)
        let viewController = EpisodeDetailViewController(viewModel: viewModel, coordinator: self)
        self.navigationController?.present(viewController, animated: true)
    }
}
