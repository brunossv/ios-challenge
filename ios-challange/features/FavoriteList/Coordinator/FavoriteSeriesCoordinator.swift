//
//  FavoriteSeriesCoordinator.swift
//  ios-challange
//
//  Created by Bruno Soares on 16/01/25.
//
import UIKit

class FavoriteSeriesCoordinator: Coordinator {
    var childCoordinator: [Coordinator]
    
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController? = nil) {
        self.childCoordinator = []
        self.navigationController = navigationController
    }
    
    func start() {
        let favoriteViewController = FavoriteSeriesController(viewModel: FavoriteSeriesListViewModel())
        favoriteViewController.coordinator = self
        self.navigationController?.pushViewController(favoriteViewController, animated: true)
    }
}

extension FavoriteSeriesCoordinator: SeriesListCoordinatorProtocol {
    
}
