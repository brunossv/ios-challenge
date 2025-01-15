//
//  SeriesListCollectionViewCell.swift
//  ios-challange
//
//  Created by Bruno Soares on 15/01/25.
//
import UIKit
import Foundation

class SeriesListCollectionViewCell: UICollectionViewCell {
    
    private lazy var posterImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        view.backgroundColor = UIColor(white: 0.9, alpha: 1)
        
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 1

        return view
    }()
    
    var title: String? {
        get { return self.titleLabel.text }
        set { self.titleLabel.text = newValue }
    }
    
    var poster: UIImage? {
        get { return self.posterImageView.image }
        set { self.posterImageView.image = newValue }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    func initialize() {
        self.configureSubviews()
    }
    
    private func configureSubviews() {
        self.contentView.addSubview(self.posterImageView)
        self.contentView.addSubview(self.titleLabel)
        
        let constant: CGFloat = 5
        let posterHeight: CGFloat = 160
        let posterWidth: CGFloat = 100
        NSLayoutConstraint.activate([
            self.posterImageView.topAnchor.constraint(lessThanOrEqualTo: self.contentView.topAnchor, constant: 0),
            self.posterImageView.leftAnchor.constraint(lessThanOrEqualTo: self.contentView.leftAnchor, constant: constant),
            self.posterImageView.rightAnchor.constraint(lessThanOrEqualTo: self.contentView.rightAnchor, constant: constant),
            self.posterImageView.heightAnchor.constraint(equalToConstant: posterHeight),
            self.posterImageView.widthAnchor.constraint(equalToConstant: posterWidth)
        ])
        
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.posterImageView.bottomAnchor, constant: constant),
            self.titleLabel.leftAnchor.constraint(equalTo: self.posterImageView.leftAnchor),
            self.titleLabel.rightAnchor.constraint(equalTo: self.posterImageView.rightAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initialize()
    }
}
