//
//  Coordinator.swift
//  ios-challange
//
//  Created by Bruno Soares on 14/01/25.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinator: [Coordinator] { get set }
    var navigationController: UINavigationController? { get set }
    func start()
}

extension Coordinator {
    func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func dismiss(_ handler: (() -> Void)? = nil) {
        self.navigationController?.dismiss(animated: true)
    }
}
