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
