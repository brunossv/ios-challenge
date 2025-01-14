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

class SeriesListTableViewCell: UITableViewCell {
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        
        return view
    }()
    
    var title: String? {
        get { return self.titleLabel.text }
        set { self.titleLabel.text = newValue }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initialize()
    }
    
    func initialize() {
        self.configureSubviews()
    }
    
    private func configureSubviews() {
        self.contentView.addSubview(self.titleLabel)
        
        let constant: CGFloat = 10
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: constant),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: constant),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -constant),
            self.titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -constant),
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initialize()
    }
}
