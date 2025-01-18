//
//  
//  EpisodesListViewController.swift
//  ios-challange
//
//  Created by Bruno Soares on 17/01/25.
//
//

import Foundation
import UIKit

class EpisodesListViewController: UIViewController {
    enum Cells: CaseIterable {
        case cell
        
        var identifier: String {
            switch self {
            case .cell:
                return "EpisodeDetailTableViewCell"
            }
        }
        
        var `class`: AnyClass? {
            switch self {
            case .cell:
                return EpisodeDetailTableViewCell.self
            }
        }
    }
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let viewModel: EpisodesListViewModel
    
    weak var coordinator: SeriesListCoordinatorProtocol?
    
    init(viewModel: EpisodesListViewModel, coordinator: SeriesListCoordinatorProtocol?) {
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
}

extension EpisodesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        if row < self.viewModel.model.count {
            let model = self.viewModel.model[row]
            self.coordinator?.openEpisodeDetail(model: model)
        }
    }
}

extension EpisodesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let model = self.viewModel.model.first
        return "Season \(model?.season ?? 0)"
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.model.count
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
        if row < self.viewModel.model.count {
            let cell: EpisodeDetailTableViewCell = dequeue(with: .cell)
            let model = self.viewModel.model[row]
            cell.name = model.name
            cell.seasonEp = "S\(model.season ?? 0)EP\(model.number ?? 0)"
            
            if let url = model.image?.medium {
                Task {
                    cell.posterImage = try? await Services().loadImage(url)
                }
            }
            return cell
        }
        return .init(frame: .zero)
    }
}
