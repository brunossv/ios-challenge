//
//  
//  SettingsViewController.swift
//  ios-challange
//
//  Created by Bruno Soares on 21/01/25.
//
//

import Foundation
import UIKit
import LocalAuthentication

class SettingsViewController: UIViewController {
    enum Cells: CaseIterable {
        case cell
        
        var identifier: String {
            switch self {
            case .cell:
                return "SettingsTableViewCell"
            }
        }
        
        var `class`: AnyClass? {
            switch self {
            case .cell:
                return SettingsTableViewCell.self
            }
        }
    }
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var viewModel: SettingsViewModel = SettingsViewModel()
    
    weak var coordinator: SettingsCoordinatorProtocol?
    
    init(viewModel: SettingsViewModel, coordinator: SettingsCoordinatorProtocol? = nil) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
    }
    
    func configureTableView() {
        self.view.addSubview(self.tableView)
        self.view.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.tableView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        for cell in Cells.allCases {
            self.tableView.register(cell.class, forCellReuseIdentifier: cell.identifier)
        }
    }
    
    private var laContext = LAContext()
    
    private func settingUpLockScreen(_ completion: @escaping (Bool) -> Void) {
        switch self.laContext.biometryType {
        case .faceID, .touchID, .opticID:
            self.settingUpAuthentication(policy: .deviceOwnerAuthenticationWithBiometrics, completion)
            break
        case .none:
            self.settingUpAuthentication(policy: .deviceOwnerAuthentication, completion)
            break
        default:
            fatalError()
        }
    }
    
    private func settingUpAuthentication(policy: LAPolicy,_ completion: @escaping (Bool) -> Void) {
        var error: NSError?
        guard self.laContext.canEvaluatePolicy(policy, error: &error) else {
            print(error?.localizedDescription ?? "Can't evaluate policy")
            return
        }
        
        Task {
            do {
                try await self.laContext.evaluatePolicy(policy, localizedReason: "Unlock screen")
                completion(true)
            } catch {
                completion(false)
            }
        }
    }
}

extension SettingsViewController: SettingsTableViewCellDelegate {
    func updateValue(_ value: Bool, for setting: SettingsTableViewCell) {
        
        guard value else {
            if let indexPath = self.tableView.indexPath(for: setting),
               let model = SettingsViewModel.Settings(rawValue: indexPath.row) {
                self.viewModel.values[model] = value
                UserDefaults.standard.set(value, forKey: model.id)
                UserDefaults.standard.synchronize()
            }
            return
        }
        
        self.settingUpLockScreen { [weak self] appoved in
            if appoved {
                if let indexPath = self?.tableView.indexPath(for: setting),
                   let model = SettingsViewModel.Settings(rawValue: indexPath.row) {
                    self?.viewModel.values[model] = value
                    UserDefaults.standard.set(value, forKey: model.id)
                    UserDefaults.standard.synchronize()
                }
            }
        }
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingsViewModel.Settings.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        func dequeue<T: UITableViewCell>(with identifier: Cells) -> T {
            if let cell = tableView.dequeueReusableCell(withIdentifier: identifier.identifier, for: indexPath) as? T {
                return cell
            } else {
                return T(style: .default, reuseIdentifier: identifier.identifier)
            }
        }
        
        let row = indexPath.row
        let cell: SettingsTableViewCell = dequeue(with: .cell)
        if let model = SettingsViewModel.Settings(rawValue: row) {
            cell.title = model.title
            cell.icon = UIImage(systemName: model.icon)
            cell.isOn = self.viewModel.values[model] ?? false
            cell.delegate = self
        }
        return cell
    }
}
