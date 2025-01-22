//
//  
//  StarSearchDetailTableViewCell.swift
//  ios-challange
//
//  Created by Bruno Soares on 21/01/25.
//
//

import Foundation
import UIKit

class StarSearchDetailTableViewCell: UITableViewCell {
    
    private lazy var actorImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 75
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
        
        return view
    }()
    
    var titleString: String? {
        get { return self.titleLabel.text }
        set { self.titleLabel.text = newValue }
    }
    
    var actorImage: UIImage? {
        get { return self.actorImageView.image }
        set { self.actorImageView.image = newValue }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initialize()
    }
    
    func initialize() {
        self.configureSubviews()
    }
    
    private func configureSubviews() {
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.actorImageView)
        
        let constant: CGFloat = 10
        NSLayoutConstraint.activate([
            self.actorImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: constant),
            self.actorImageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.actorImageView.heightAnchor.constraint(equalToConstant: 150),
            self.actorImageView.widthAnchor.constraint(equalToConstant: 150),
        ])
        
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.actorImageView.bottomAnchor, constant: constant),
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
