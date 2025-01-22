//
//  
//  StarSearchViewController.swift
//  ios-challange
//
//  Created by Bruno Soares on 20/01/25.
//
//

import Foundation
import UIKit

class StarSearchViewController: UIViewController {
    enum Cells: CaseIterable {
        case cell
        
        var identifier: String {
            switch self {
            case .cell:
                return "StarSearchTableViewCell"
            }
        }
        
        var `class`: AnyClass? {
            switch self {
            case .cell:
                return StarSearchTableViewCell.self
            }
        }
    }
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var viewModel: StarSearchViewModel
    
    weak var coordinator: StarSearchCoordinatorProtocol?
    
    init(viewModel: StarSearchViewModel, coordinator: StarSearchCoordinatorProtocol? = nil) {
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
        self.configureSearchBar()
        self.getData()
    }
    
    func getData() {
        Alert(self).startLoading()
        self.viewModel.getData { error in
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
    
    func configureSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.returnKeyType = .search
        searchController.searchBar.searchBarStyle = .default
        searchController.searchBar.delegate = self
        self.navigationItem.searchController = searchController
        self.tabBarController?.delegate = self
    }
}

extension StarSearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.viewModel.endSearch()
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        Alert(self).startLoading()
        self.viewModel.request(by: searchBar.text ?? "") { [weak self] error in
            Alert(self).stopLoading()
            searchBar.barStyle = .default
            self?.tableView.reloadData()
        }
    }
}

extension StarSearchViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let indexPath = IndexPath(row: 0, section: 0)
        if self.navigationController == viewController, indexPath.row < self.tableView.numberOfRows(inSection: 0) {
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
}

extension StarSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        if let model = self.viewModel.model, row < model.count {
            self.coordinator?.openCastCredits(for: model[row])
        }
    }
}

extension StarSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard self.viewModel.allowPagination else {
            return
        }
        
        if ((self.viewModel.model?.count ?? 0) - 1) == indexPath.row {
            Alert(self).startLoading()
            self.viewModel.getNextPage { [weak self] error in
                Alert(self).stopLoading()
                self?.tableView.reloadData()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.model?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        func dequeue<T: UITableViewCell>(with identifier: Cells) -> T {
            if let cell = tableView.dequeueReusableCell(withIdentifier: identifier.identifier, for: indexPath) as? T {
                return cell
            } else {
                return T(style: .default, reuseIdentifier: identifier.identifier)
            }
        }
        
        let cell: StarSearchTableViewCell = dequeue(with: .cell)
        let row = indexPath.row
        if let model = self.viewModel.model, row < model.count {
            cell.actorString = model[row].name
            if let url = model[row].image?.medium {
                Task {
                    cell.casterImage = try? await Services().loadImage(url)
                }
            }
        }
        
        return cell
    }
}
