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
    
    private lazy var casterLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 1
        view.textAlignment = .center
        
        return view
    }()
    
    private lazy var actorLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 1
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
        return view
    }()
    
    var casterString: String? {
        get { return self.casterLabel.text }
        set { self.casterLabel.text = newValue }
    }
    
    var actorString: String? {
        get { return self.actorLabel.text }
        set { self.actorLabel.text = newValue }
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
        self.addSubview(self.casterLabel)
        self.addSubview(self.actorLabel)
        
        let constant: CGFloat = 5
        let imageSpacing: CGFloat = 25
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
            self.casterLabel.topAnchor.constraint(equalTo: self.casterImageView.bottomAnchor, constant: constant),
            self.casterLabel.widthAnchor.constraint(equalTo: self.widthAnchor),
            self.casterLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            self.actorLabel.topAnchor.constraint(equalTo: self.casterLabel.bottomAnchor),
            self.actorLabel.widthAnchor.constraint(equalTo: self.widthAnchor),
            self.actorLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.actorLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        self.casterImageView.layer.cornerRadius = (posterHeight / 2)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initialize()
    }
}
