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

protocol SeriesListCoordinatorProtocol: AnyObject {
    
}

class SeriesListCoordinator: Coordinator {
    var childCoordinator: [Coordinator]
    
    var navigationController: UINavigationController?
    
    weak var coordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinator = []
    }
    
    func start() {
        let viewController = SeriesListViewController()
        viewController.coordinator = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension SeriesListCoordinator: SeriesListCoordinatorProtocol {
    
}
