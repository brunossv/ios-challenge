//
//  
//  SeriesListViewController.swift
//  ios-challange
//
//  Created by Bruno Soares on 14/01/25.
//
//

import Foundation
import UIKit

class SeriesListViewController: UIViewController {
    enum Cells: CaseIterable {
        case cell
        
        var identifier: String {
            switch self {
            case .cell:
                return "SeriesListTableViewCell"
            }
        }
        
        var `class`: AnyClass? {
            switch self {
            case .cell:
                return SeriesListTableViewCell.self
            }
        }
    }
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.allowsSelection = false
        
        return view
    }()
    
    var viewModel: SeriesListViewModelProtocol
    
    weak var coordinator: SeriesListCoordinatorProtocol?
    
    init(viewModel: SeriesListViewModelProtocol, coordinator: SeriesListCoordinatorProtocol? = nil) {
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
        self.configureSearchBar()
        self.configureNavigationButtons()
    }
    
    func configureSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.returnKeyType = .search
        searchController.searchBar.searchTextField.delegate = self
        searchController.searchBar.searchBarStyle = .minimal
        
        self.navigationItem.searchController = searchController
    }
    
    func getData() {
        Alert(self).startLoading()
        self.viewModel.request { [weak self] error in
            Alert(self).stopLoading()
            self?.tableView.refreshControl?.endRefreshing()
            if let error = error {
                Alert(self).present(error: error)
                return
            }
            self?.tableView.reloadData()
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
    
    func configureNavigationButtons() {
        
    }
}

extension SeriesListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        Alert(self).startLoading()
        self.viewModel.searchShow(by: textField.text ?? "") { [weak self] error in
            Alert(self).stopLoading()
            self?.tableView.reloadData()
        }
        
        return true
    }
}

extension SeriesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SeriesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let model = self.viewModel.model, section < model.count {
            let genresTitle = model[section].first?.genres?.first
            let typeTitle = model[section].first?.type
            return genresTitle ?? typeTitle ?? ""
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 205
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.model?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        func dequeue<T: UITableViewCell>(with identifier: Cells) -> T {
            if let cell = tableView.dequeueReusableCell(withIdentifier: identifier.identifier, for: indexPath) as? T {
                return cell
            } else {
                return T(style: .default, reuseIdentifier: identifier.identifier)
            }
        }
        let cell: SeriesListTableViewCell = dequeue(with: .cell)
        cell.dataSource = self
        cell.collectionView.reloadData()
        return cell
    }
}

extension SeriesListViewController: SeriesListTableViewCellDataSource {
    func seriesListTableViewCell(numberOfItems cell: SeriesListTableViewCell) -> Int {
        if let model = self.viewModel.model,
            let indexPath = self.tableView.indexPath(for: cell), indexPath.section < model.count {
            let rows = model[indexPath.section]
            return rows.count
        }
        
        return 0
    }
    
    func seriesListTableViewCell(_ cell: SeriesListTableViewCell, didSelectItem at: IndexPath) {
        
    }
    
    func seriesListTableViewCell(_ collectionView: UICollectionView, _ cell: SeriesListTableViewCell, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        func dequeue<T: UICollectionViewCell>(with identifier: String,_ indexPath: IndexPath) -> T {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T {
                return cell
            } else {
                return T(frame: .zero)
            }
        }
        
        if let model = self.viewModel.model,
           let tableIndexPath = self.tableView.indexPath(for: cell),
            tableIndexPath.section < model.count, indexPath.row < model[tableIndexPath.section].count {
            let section = tableIndexPath.section
            let row = indexPath.row
            
            let itemModel = model[section][row]
            let identifier = SeriesListTableViewCell.Cells.posters.identifier
            
            let cell: SeriesListCollectionViewCell = dequeue(with: identifier, indexPath)
            cell.title = itemModel.name
            if let url = itemModel.image?.medium {
                Task {
                    cell.poster = try? await Services().loadImage(url)
                }
            }
            
            return cell
        }
        
        return .init(frame: .zero)
    }
    
    
}
