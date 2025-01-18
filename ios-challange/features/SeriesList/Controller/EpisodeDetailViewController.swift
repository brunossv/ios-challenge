//
//  EpisodeDetailViewController.swift
//  ios-challange
//
//  Created by Bruno Soares on 18/01/25.
//

import Foundation
import UIKit

class EpisodeDetailViewController: UIViewController {
    
    private lazy var episodeView: EpisodeDetailView = {
        let view = EpisodeDetailView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var closeButton: UIButton = {
        let view = UIButton(type: .close)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerCurve = .circular
        
        return view
    }()
    
    let viewModel: EpisodeDetailViewModel
    
    weak var coordinator: SeriesListCoordinatorProtocol?
    
    init(viewModel: EpisodeDetailViewModel, coordinator: SeriesListCoordinatorProtocol?) {
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
        self.view.addSubview(self.episodeView)
        self.view.addSubview(self.closeButton)
        
        self.view.backgroundColor = .systemBackground
        let constant: CGFloat = 15
        NSLayoutConstraint.activate([
            self.closeButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: constant),
            self.closeButton.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -constant),
            self.closeButton.heightAnchor.constraint(equalToConstant: 40),
            self.closeButton.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            self.episodeView.topAnchor.constraint(equalTo: self.closeButton.bottomAnchor, constant: 5),
            self.episodeView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            self.episodeView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            self.episodeView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        let model = self.viewModel.model
        self.episodeView.name = model.name
        self.episodeView.seasonEp = "S\(model.season ?? 0)EP\(model.number ?? 0)"
        self.episodeView.summary = model.summary
        
        if let url = model.image?.original {
            Task {
                self.episodeView.posterImage = try? await Services().loadImage(url)
            }
        }
        
        self.closeButton.addTarget(self, action: #selector(self.close), for: .touchUpInside)
    }
    
    @objc
    func close() {
        self.coordinator?.dismiss()
    }
}
