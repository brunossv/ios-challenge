//
//  EpisodeDetailView.swift
//  ios-challange
//
//  Created by Bruno Soares on 18/01/25.
//
import UIKit
import Foundation

class EpisodeDetailView: UIView {
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 10
        
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
    
    private lazy var summaryLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        
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
    
    var summary: String? {
        didSet {
            if let summary = self.summary {
                let textAttributed = try? NSAttributedString(data: Data(summary.utf8), options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding:String.Encoding.utf8.rawValue
                ], documentAttributes: nil)
                self.summaryLabel.attributedText = textAttributed
                self.summaryLabel.attributedText = NSAttributedString(string: textAttributed?.string ?? "", attributes: [.font:UIFont.systemFont(ofSize: 17)])
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    func initialize() {
        self.configureSubviews()
    }
    
    private func configureSubviews() {
        self.addSubview(self.posterImageView)
        self.addSubview(self.stackView)
        
        let constant: CGFloat = 10
        let posterHeight: CGFloat = 100
        NSLayoutConstraint.activate([
            self.posterImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: constant),
            self.posterImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: constant),
            self.posterImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -constant),
            self.posterImageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5)
        ])
        
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.posterImageView.bottomAnchor, constant: constant),
            self.stackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: constant),
            self.stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -constant),
            self.stackView.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -constant)
        ])
        
        self.stackView.addArrangedSubview(self.nameLabel)
        self.stackView.addArrangedSubview(self.seasonEpLabel)
        self.stackView.addArrangedSubview(self.summaryLabel)
        
        self.stackView.setCustomSpacing(15, after: self.seasonEpLabel)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initialize()
    }
}
