//
//  
//  BlockScreenViewController.swift
//  ios-challange
//
//  Created by Bruno Soares on 22/01/25.
//
//

import Foundation
import UIKit
import LocalAuthentication

class BlockScreenViewController: UIViewController {
    
    private lazy var mainView: BlockScreenView = {
        let view = BlockScreenView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    weak var coordinator: MainCoordinatorProtocol?
    
    override func loadView() {
        self.view = self.mainView
    }
    
    init(coordinator: MainCoordinatorProtocol) {
        self.coordinator = coordinator
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.settingUpLockScreen()
    }
    
    func settingUpLockScreen() {
        let model = AppAuthentication()
        model.askAuthentication { error in
            if let error = error {
                Alert(self).present(message: error)
                return
            }
            self.coordinator?.authorized()
        }
    }
}

extension BlockScreenViewController: BlockScreenViewDelegate {
    func tryAgain(_ sender: UIButton) {
        self.settingUpLockScreen()
    }
}
