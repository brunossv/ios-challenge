//
//  
//  SeriesListCoordinator.swift
//  ios-challange
//
//  Created by Bruno Soares on 14/01/25.
//
//

import Foundation
import UIKit

protocol SeriesListCoordinatorProtocol: Coordinator {
    func openSeriesDetail(model: SeriesListModel)
    func openEpisodeList(model: [EpisodeModel])
    func openEpisodeDetail(model: EpisodeModel)
}

class SeriesListCoordinator {
    var childCoordinator: [Coordinator]
    
    var navigationController: UINavigationController?
    
    weak var coordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinator = []
    }
    
    func start() {
        let viewController = ScheduleSeriesListViewController(viewModel: SeriesListViewModel(), coordinator: self)
        viewController.title = MainCoordinator.Tabs.live.title
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension SeriesListCoordinator: SeriesListCoordinatorProtocol {
    func openSeriesDetail(model: SeriesListModel) {
        let viewModel = SeriesDetailViewModel(seriesModel: model)
        let viewController = SeriesDetailViewController(viewModel: viewModel, coordinator: self)
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
