//
//  
//  EpisodeDetailTableViewCell.swift
//  ios-challange
//
//  Created by Bruno Soares on 17/01/25.
//
//

import Foundation
import UIKit

class EpisodeDetailTableViewCell: UITableViewCell {
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 5
        
        return view
    }()
    
    private lazy var posterImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        view.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        
        return view
    }()
    
    private lazy var seasonEpLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        
        return view
    }()
    
    var posterImage: UIImage? {
        get { return self.posterImageView.image }
        set { self.posterImageView.image = newValue }
    }
    
    var name: String? {
        get { return self.nameLabel.text }
        set { self.nameLabel.text = newValue }
    }
    
    var seasonEp: String? {
        get { return self.seasonEpLabel.text }
        set { self.seasonEpLabel.text = newValue }
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
        self.contentView.addSubview(self.stackView)
        
        let constant: CGFloat = 10
        let posterHeight: CGFloat = 100
        let posterWidth: CGFloat = 150
        NSLayoutConstraint.activate([
            self.posterImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: constant),
            self.posterImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: constant),
            self.posterImageView.heightAnchor.constraint(equalToConstant: posterHeight),
            self.posterImageView.widthAnchor.constraint(equalToConstant: posterWidth),
            self.posterImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -constant)
        ])
        
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.posterImageView.topAnchor),
            self.stackView.leftAnchor.constraint(equalTo: self.posterImageView.rightAnchor, constant: constant),
            self.stackView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor)
        ])
        
        self.stackView.addArrangedSubview(self.nameLabel)
        self.stackView.addArrangedSubview(self.seasonEpLabel)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initialize()
    }
}
