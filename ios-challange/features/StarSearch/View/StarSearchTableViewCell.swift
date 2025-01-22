//
// 
//  StarSearchTableViewCell.swift
//  ios-challange
//
//  Created by Bruno Soares on 20/01/25.
//
//

import Foundation
import UIKit

class StarSearchTableViewCell: UITableViewCell {
    
    private lazy var casterImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        view.backgroundColor = UIColor(white: 0.9, alpha: 1)
        
        return view
    }()
    
    private lazy var casterLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 1
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
        
        return view
    }()
    
    var actorString: String? {
        get { return self.casterLabel.text }
        set { self.casterLabel.text = newValue }
    }
    
    var casterImage: UIImage? {
        get { return self.casterImageView.image }
        set { self.casterImageView.image = newValue }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initialize()
    }
    
    func initialize() {
        self.configureSubviews()
    }
    
    private func configureSubviews() {
        self.contentView.addSubview(self.casterImageView)
        self.contentView.addSubview(self.casterLabel)
        
        let constant: CGFloat = 5
        let imageSpacing: CGFloat = 25
        let posterHeight: CGFloat = 75
        let posterWidth: CGFloat = 75
        NSLayoutConstraint.activate([
            self.casterImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: constant),
            self.casterImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: constant),
            self.casterImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -constant),
            self.casterImageView.heightAnchor.constraint(equalToConstant: posterHeight),
            self.casterImageView.widthAnchor.constraint(equalToConstant: posterWidth)
        ])
        
        NSLayoutConstraint.activate([
            self.casterLabel.leftAnchor.constraint(equalTo: self.casterImageView.rightAnchor, constant: constant),
            self.casterLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
        
        self.casterImageView.layer.cornerRadius = (posterHeight / 2)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initialize()
    }
}
