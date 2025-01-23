//
//  
//  SettingsCoordinator.swift
//  ios-challange
//
//  Created by Bruno Soares on 21/01/25.
//
//

import Foundation
import UIKit

protocol SettingsCoordinatorProtocol: Coordinator {
    
}

class SettingsCoordinator {
    var childCoordinator: [Coordinator]
    
    var navigationController: UINavigationController?
    
    weak var coordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinator = []
    }
    
    func start() {
        let viewModel = SettingsViewModel()
        let viewController = SettingsViewController(viewModel: viewModel, coordinator: self)
        viewController.title = MainCoordinator.Tabs.settings.title
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension SettingsCoordinator: SettingsCoordinatorProtocol {
    
}
