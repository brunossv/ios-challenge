//
//  ScheduleSeriesListViewController.swift
//  ios-challange
//
//  Created by Bruno Soares on 15/01/25.
//

import Foundation
import UIKit

class ScheduleSeriesListViewController: SeriesListViewController {
    override func configureNavigationButtons() {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.refreshListAction()
        }), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    func refreshListAction() {
        self.getData()
        self.navigationItem.searchController?.searchBar.text = nil
    }
}


extension ScheduleSeriesListViewController {
    override func seriesListTableViewCell(_ cell: SeriesListTableViewCell, didSelectItem at: IndexPath) {
        let section = at.section
        let row = at.row
        
        if let list = self.viewModel.model, section < list.count, row < list[section].count {
            let model = list[section][row]
            if !FavoriteSeriesModel().alreadyFavorite(name: model.name ?? "") {
                FavoriteSeriesModel().saveSeries(model)
            }
        }
    }
}

extension ScheduleSeriesListViewController {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard self.viewModel.allowPagination else {
            return
        }
        
        if ((self.viewModel.model?.count ?? 0) - 1) == indexPath.section {
            Alert(self).startLoading()
            let viewModel = self.viewModel as? SeriesListPaginationViewModelProtocol
            viewModel?.getNextPage { [weak self] in
                Alert(self).stopLoading()
                self?.tableView.reloadData()
            }
        }
    }
}
