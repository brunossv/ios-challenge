//
// 
//  SeriesListTableViewCell.swift
//  ios-challange
//
//  Created by Bruno Soares on 14/01/25.
//
//

import Foundation
import UIKit

protocol SeriesListTableViewCellDataSource: AnyObject {
    func seriesListTableViewCell(numberOfItems cell: SeriesListTableViewCell) -> Int
    func seriesListTableViewCell(_ cell: SeriesListTableViewCell, didSelectItem at: IndexPath)
    func seriesListTableViewCell(_ collectionView: UICollectionView, _ cell: SeriesListTableViewCell, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}

class SeriesListTableViewCell: UITableViewCell {
    
    enum Cells: CaseIterable {
        case posters
        
        var identifier: String {
            switch self {
            case .posters:
                return "SeriesListCollectionViewCell"
            }
        }
        
        var `class`: AnyClass? {
            switch self {
            case .posters:
                return SeriesListCollectionViewCell.self
            }
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 110, height: 190)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    weak var dataSource: SeriesListTableViewCellDataSource?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initialize()
    }
    
    func initialize() {
        self.configureSubviews()
    }
    
    private func configureSubviews() {
        self.contentView.addSubview(self.collectionView)
        
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            self.collectionView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            self.collectionView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            self.collectionView.heightAnchor.constraint(equalToConstant: 195)
        ])
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        for cell in Cells.allCases {
            self.collectionView.register(cell.class, forCellWithReuseIdentifier: cell.identifier)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initialize()
    }
}

extension SeriesListTableViewCell: UICollectionViewDelegate {
    
}

extension SeriesListTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110, height: 190)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource?.seriesListTableViewCell(numberOfItems: self) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return self.dataSource?.seriesListTableViewCell(collectionView, self, cellForItemAt: indexPath) ?? .init(frame: .zero)
    }
}
