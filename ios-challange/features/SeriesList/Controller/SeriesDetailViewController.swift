//
//  
//  SeriesDetailViewController.swift
//  ios-challange
//
//  Created by Bruno Soares on 16/01/25.
//
//

import Foundation
import UIKit

class SeriesDetailViewController: UIViewController {
    enum Cells: CaseIterable {
        case info
        case cast
        case seasons
        
        var identifier: String {
            switch self {
            case .info:
                return "SeriesDetailTableViewCell"
            case .cast:
                return "cast"
            case .seasons:
                return "seasons"
            }
        }
        
        var `class`: AnyClass? {
            switch self {
            case .info:
                return SeriesDetailTableViewCell.self
            case .cast:
                return SeriesCastTableViewCell.self
            case .seasons:
                return UITableViewCell.self
            }
        }
    }
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.estimatedRowHeight = 250
        
        return view
    }()
    
    private lazy var favoriteButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var viewModel: SeriesDetailViewModel
    
    weak var coordinator: SeriesListCoordinatorProtocol?
    
    init(viewModel: SeriesDetailViewModel, coordinator: SeriesListCoordinatorProtocol) {
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
        self.configureNavButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getData()
    }
    
    func getData() {
        Alert(self).startLoading()
        self.viewModel.requestSeriesInfo { [weak self] error in
            Alert(self).stopLoading()
            self?.tableView.reloadData()
        }
    }
    
    func configureNavButtons() {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.setImage(UIImage(systemName: "bookmark.fill"), for: .selected)
        button.isSelected = self.viewModel.seriesSaved()
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.favoriteNavButton(button)
        }), for: .touchUpInside)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    @objc
    func favoriteNavButton(_ sender: UIButton) {
        if sender.isSelected {
            self.viewModel.deleteSeriesSaved()
            sender.isSelected = false
        } else {
            Alert(self).startLoading()
            self.viewModel.saveSeriesFavorites { [weak self] error in
                Alert(self).stopLoading()
                sender.isSelected = true
            }
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

extension SeriesDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let section = SeriesDetailViewModel.Sections(rawValue: indexPath.section),
        section == .seasons else { return }
        let row = indexPath.row
        if let seasons = self.viewModel.seriesModel?.seasons, row < seasons.count {
            let season = seasons[row]
            Alert(self).startLoading()
            self.viewModel.requestEpisodes(seasonID: season.id ?? 0) { [weak self] error in
                Alert(self).stopLoading {
                    let episodes = self?.viewModel.seriesModel?.seasons?[row].episodes ?? []
                    self?.coordinator?.openEpisodeList(model: episodes)
                }
            }
        }
    }
}

extension SeriesDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SeriesDetailViewModel.Sections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = SeriesDetailViewModel.Sections(rawValue: section) else {
            return 0
        }
        
        switch section {
        case .info, .cast:
            return 1
        case .seasons:
            return self.viewModel.seriesModel?.seasons?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        func addingComma(_ array: [String]) -> String {
            var string: String = ""
            for i in 0..<array.count {
                string += i == (array.count - 1) ? array[i] : array[i] + ", "
            }
            return string
        }
        func dequeue<T: UITableViewCell>(with identifier: Cells) -> T {
            if let cell = tableView.dequeueReusableCell(withIdentifier: identifier.identifier, for: indexPath) as? T {
                return cell
            } else {
                return T(style: .default, reuseIdentifier: identifier.identifier)
            }
        }
        
        let section = indexPath.section
        if let section = SeriesDetailViewModel.Sections(rawValue: section) {
            switch section {
            case .info:
                let infoCell: SeriesDetailTableViewCell = dequeue(with: .info)
                infoCell.name = self.viewModel.seriesModel?.name
                infoCell.summary = self.viewModel.seriesModel?.summary
                if let url = self.viewModel.seriesModel?.image?.medium {
                    Task {
                        infoCell.posterImage = try? await Services().loadImage(url)
                    }
                }
                
                if let genresArray = self.viewModel.seriesModel?.genres {
                    infoCell.genres = addingComma(genresArray)
                }
                
                if let daysArray = self.viewModel.seriesModel?.schedule?.days {
                    infoCell.days = addingComma(daysArray)
                }
                
                infoCell.time = self.viewModel.seriesModel?.schedule?.time
                
                return infoCell

            case .cast:
                let castCell: SeriesCastTableViewCell = dequeue(with: .cast)
                if let casters = self.viewModel.seriesModel?.casters {
                    castCell.setupCollection(of: casters.count) { item in
                        if item < casters.count {
                            let image = casters[item].person?.image?.medium ?? ""
                            let name = casters[item].person?.name ?? ""
                            let caster = casters[item].character?.name ?? ""
                            return (image, caster, name)
                        } else {
                            return ("", "", "")
                        }
                    }
                }
                return castCell
            case .seasons:
                let seasonsCell: UITableViewCell = dequeue(with: .seasons)
                let row = indexPath.row
                if let seasons = self.viewModel.seriesModel?.seasons, row < seasons.count {
                    let model = seasons[row]
                    var content = seasonsCell.defaultContentConfiguration()
                    content.text = "Season \(model.number ?? 0)"
                    seasonsCell.accessoryType = .disclosureIndicator
                    seasonsCell.contentConfiguration = content
                }
                return seasonsCell
            }
        }
        
        return .init(frame: .zero)
    }
}
