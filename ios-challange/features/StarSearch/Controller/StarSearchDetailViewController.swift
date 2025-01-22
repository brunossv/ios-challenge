//
//
//  StarSearchDetailViewController.swift
//  ios-challange
//
//  Created by Bruno Soares on 21/01/25.
//
//

import Foundation
import UIKit

class StarSearchDetailViewController: UIViewController {
    enum Cells: CaseIterable {
        case actor
        case shows
        
        var identifier: String {
            switch self {
            case .actor:
                return "StarSearchDetailTableViewCell"
            case .shows:
                return "shows"
            }
        }
        
        var `class`: AnyClass? {
            switch self {
            case .actor:
                return StarSearchDetailTableViewCell.self
            case .shows:
                return UITableViewCell.self
            }
        }
    }
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var viewModel: StarSearchDetailViewModel
    
    weak var coordinator: StarSearchCoordinatorProtocol?
    
    init(viewModel: StarSearchDetailViewModel, coordinator: StarSearchCoordinatorProtocol?) {
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
        self.getData()
    }
    
    func getData() {
        Alert(self).startLoading()
        self.viewModel.request { error in
            Alert(self).stopLoading()
            if let error = error {
                Alert(self).present(error: error)
                return
            }
            self.tableView.reloadData()
        }
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
}

extension StarSearchDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        if let castcredits = self.viewModel.model._embedded?.castcredits, row < castcredits.count,
           let urlString = castcredits[row]._links?.show?.href, let url = URL(string: urlString) {
            Alert(self).startLoading()
            self.viewModel.getSeriesInfo(url: urlString) { urlString in
                Alert(self).stopLoading()
                if let url = URL(string: urlString ?? "") {
                    UIApplication.shared.open(url)
                } else {
                    Alert(self).present(error: "Error showing Series")
                }
            }
        }
    }
}

extension StarSearchDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return StarSearchDetailViewModel.Sections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let section = StarSearchDetailViewModel.Sections(rawValue: section) {
            switch section {
            case .actor:
                return 1
            case .shows:
                return self.viewModel.model._embedded?.castcredits?.count ?? 0
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        func dequeue<T: UITableViewCell>(with identifier: Cells) -> T {
            if let cell = tableView.dequeueReusableCell(withIdentifier: identifier.identifier, for: indexPath) as? T {
                return cell
            } else {
                return T(style: .default, reuseIdentifier: identifier.identifier)
            }
        }
        let section = indexPath.section
        
        if let section = StarSearchDetailViewModel.Sections(rawValue: section) {
            switch section {
            case .actor:
                let cell: StarSearchDetailTableViewCell = dequeue(with: .actor)
                cell.titleString = self.viewModel.model.name
                if let url = self.viewModel.model.image?.original {
                    Task {
                        cell.actorImage = try? await Services().loadImage(url)
                    }
                }
                return cell
            case .shows:
                let cell: UITableViewCell = dequeue(with: .shows)
                let row = indexPath.row
                if let castcredits = self.viewModel.model._embedded?.castcredits, row < castcredits.count {
                    var content = cell.defaultContentConfiguration()
                    content.text = castcredits[row]._links?.show?.name
                    cell.accessoryType = .disclosureIndicator
                    cell.contentConfiguration = content
                }
                return cell
            }
        }
        return .init()
    }
}
