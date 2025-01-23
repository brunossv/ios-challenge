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
    
    private var laContext = LAContext()
    
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
    
    private func settingUpLockScreen() {
        switch self.laContext.biometryType {
        case .faceID, .touchID, .opticID:
            self.settingUpAuthentication(policy: .deviceOwnerAuthenticationWithBiometrics)
            break
        case .none:
            self.settingUpAuthentication(policy: .deviceOwnerAuthentication)
            break
        default:
            fatalError()
        }
    }
    
    private func settingUpAuthentication(policy: LAPolicy) {
        var error: NSError?
        guard self.laContext.canEvaluatePolicy(policy, error: &error) else {
            print(error?.localizedDescription ?? "Can't evaluate policy")
            return
        }
        
        Task {
            do {
                try await self.laContext.evaluatePolicy(policy, localizedReason: "Unlock screen")
                self.coordinator?.authorized()
            } catch {}
        }
    }
}

extension BlockScreenViewController: BlockScreenViewDelegate {
    func tryAgain(_ sender: UIButton) {
        self.settingUpLockScreen()
    }
}
