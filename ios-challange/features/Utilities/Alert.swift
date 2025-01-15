//
//  Alert.swift
//  ios-challange
//
//  Created by Bruno Soares on 14/01/25.
//

import Foundation
import UIKit

class Alert {
    
    weak var viewController: UIViewController?
    
    init(_ viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    func present(message: String?, with handler: (() -> Void)? = nil) {
        let viewController = UIAlertController(title: "iOS-Challanger", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            handler?()
        }
        viewController.addAction(action)
        self.viewController?.present(viewController, animated: true)
    }
    
    func present(error: String?, back handler: (() -> Void)? = nil) {
        let viewController = UIAlertController(title: "iOS-Challanger", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        let voltarAction = UIAlertAction(title: "Voltar", style: .default) { _ in
            handler?()
        }
        viewController.addAction(action)
        viewController.addAction(voltarAction)
        self.viewController?.present(viewController, animated: true)
    }
    
    func startLoading() {
        let viewController = UIAlertController(title: "", message: nil, preferredStyle: .alert)
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Loading"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        
        let activity = UIActivityIndicatorView()
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.startAnimating()
        
        viewController.view.addSubview(label)
        viewController.view.addSubview(activity)
        
        NSLayoutConstraint.activate([
            activity.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            activity.trailingAnchor.constraint(equalTo: label.leadingAnchor, constant: -15),
        ])
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: viewController.view.topAnchor, constant: 10),
            label.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            label.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor, constant: -10),
        ])
        
        self.viewController?.present(viewController, animated: false)
    }
    
    func stopLoading(_ handler: (() -> Void)? = nil) {
        let viewController = self.viewController
        viewController?.dismiss(animated: false, completion: {
            handler?()
            
            if let viewController = viewController, viewController.presentedViewController is UIAlertController {
                viewController.dismiss(animated: false)
            }
        })
    }
}
