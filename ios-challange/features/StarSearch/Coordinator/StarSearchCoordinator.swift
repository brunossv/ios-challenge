//
//  
//  StarSearchCoordinator.swift
//  ios-challange
//
//  Created by Bruno Soares on 20/01/25.
//
//

import Foundation
import UIKit

protocol StarSearchCoordinatorProtocol: AnyObject {
    func openCastCredits(for model: StarSearchModel)
}

class StarSearchCoordinator: Coordinator {
    var childCoordinator: [Coordinator]
    
    var navigationController: UINavigationController?
    
    weak var coordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinator = []
    }
    
    func start() {
        let viewController = StarSearchViewController(viewModel: StarSearchViewModel(), coordinator: self)
        viewController.title = MainCoordinator.Tabs.people.title
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension StarSearchCoordinator: StarSearchCoordinatorProtocol {
    func openCastCredits(for model: StarSearchModel) {
        let viewModel = StarSearchDetailViewModel(model: model)
        let viewController = StarSearchDetailViewController(viewModel: viewModel, coordinator: self)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
