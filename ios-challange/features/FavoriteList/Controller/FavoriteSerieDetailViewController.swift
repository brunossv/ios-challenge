//
//  FavoriteSerieDetailViewController.swift
//  ios-challange
//
//  Created by Bruno Soares on 20/01/25.
//

import UIKit

class FavoriteSerieDetailViewController: SeriesDetailViewController {
    override func favoriteNavButton(_ sender: UIButton) {
        self.viewModel.deleteSeriesSaved()
        self.coordinator?.back()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let section = SeriesDetailViewModel.Sections(rawValue: indexPath.section),
        section == .seasons else { return }
        
        let row = indexPath.row
        if let seasons = self.viewModel.seriesModel?.seasons, row < seasons.count {
            let season = seasons[row]
            let episodes = season.episodes ?? []
            self.coordinator?.openEpisodeList(model: episodes)
        }
    }
}
