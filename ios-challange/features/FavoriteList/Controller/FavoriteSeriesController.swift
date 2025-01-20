//
//  FavoriteSeriesController.swift
//  ios-challange
//
//  Created by Bruno Soares on 16/01/25.
//

import UIKit

class FavoriteSeriesController: SeriesListViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getData()
    }
    
    override func getData() {
        self.viewModel.request { [weak self] error in
            self?.tableView.reloadData()
        }
    }
}
