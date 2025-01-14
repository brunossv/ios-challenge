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
    
    private lazy var posterImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
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
    
    var poster: String? {
        didSet {
            guard let url = self.poster else {
                return
            }
            
            Task {
                self.posterImageView.image = try? await Services().loadImage(url)
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initialize()
    }
    
    func initialize() {
        self.configureSubviews()
    }
    
    private func configureSubviews() {
        self.contentView.addSubview(self.posterImageView)
        self.contentView.addSubview(self.titleLabel)
        
        let constant: CGFloat = 10
        let posterHeight: CGFloat = 300
        let posterWidth: CGFloat = 200
        NSLayoutConstraint.activate([
            self.posterImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: constant),
            self.posterImageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.posterImageView.heightAnchor.constraint(equalToConstant: posterHeight),
            self.posterImageView.widthAnchor.constraint(equalToConstant: posterWidth)
        ])
        
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.posterImageView.bottomAnchor, constant: constant),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.posterImageView.leadingAnchor, constant: constant),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.posterImageView.trailingAnchor, constant: -constant),
            self.titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -constant)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initialize()
    }
}
