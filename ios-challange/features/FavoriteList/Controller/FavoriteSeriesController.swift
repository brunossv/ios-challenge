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
    
    override func configureSearchBar() {
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let model = self.viewModel.model, section < model.count {
            let sectionModel = model[section]
            
            return sectionModel.first?.name?.first?.uppercased()
        }
        return nil
    }
}
