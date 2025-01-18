//
//  SeriesCastView.swift
//  ios-challange
//
//  Created by Bruno Soares on 17/01/25.
//

import UIKit
import Foundation

class SeriesCastView: UIView {
    
    private lazy var casterImageView: UIImageView = {
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
    
    var caster: UIImage? {
        get { return self.casterImageView.image }
        set { self.casterImageView.image = newValue }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    func initialize() {
        self.configureSubviews()
    }
    
    private func configureSubviews() {
        self.addSubview(self.casterImageView)
        self.addSubview(self.titleLabel)
        
        let constant: CGFloat = 5
        let imageSpacing: CGFloat = 15
        let posterHeight: CGFloat = 75
        let posterWidth: CGFloat = 75
        NSLayoutConstraint.activate([
            self.casterImageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.casterImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: imageSpacing),
            self.casterImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -imageSpacing),
            self.casterImageView.heightAnchor.constraint(equalToConstant: posterHeight),
            self.casterImageView.widthAnchor.constraint(equalToConstant: posterWidth)
        ])
        
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.casterImageView.bottomAnchor, constant: constant),
            self.titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -constant),
        ])
        self.casterImageView.layer.cornerRadius = (posterHeight / 2)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initialize()
    }
}
