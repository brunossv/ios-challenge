//
// 
//  SeriesDetailTableViewCell.swift
//  ios-challange
//
//  Created by Bruno Soares on 16/01/25.
//
//

import Foundation
import UIKit

class SeriesDetailTableViewCell: UITableViewCell {
    
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
        view.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
        
        return view
    }()
    
    private lazy var genresLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        
        return view
    }()
    
    private lazy var daysLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        
        return view
    }()
    
    private lazy var timeLabel: UILabel = {
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
    
    var genres: String? {
        get { return self.genresLabel.text }
        set { self.genresLabel.text = newValue }
    }
    
    var days: String? {
        get { return self.daysLabel.text }
        set { self.daysLabel.text = newValue }
    }
    
    var time: String? {
        get { return self.timeLabel.text }
        set { self.timeLabel.text = newValue }
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initialize()
    }
    
    func initialize() {
        self.configureSubviews()
    }
    
    private func configureSubviews() {
        self.contentView.addSubview(self.summaryLabel)
        self.contentView.addSubview(self.posterImageView)
        self.contentView.addSubview(self.stackView)
        
        let constant: CGFloat = 10
        NSLayoutConstraint.activate([
            self.posterImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: constant),
            self.posterImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: constant),
            self.posterImageView.heightAnchor.constraint(equalToConstant: 150),
            self.posterImageView.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.posterImageView.topAnchor),
            self.stackView.leftAnchor.constraint(equalTo: self.posterImageView.rightAnchor, constant: constant),
            self.stackView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.summaryLabel.topAnchor.constraint(equalTo: self.posterImageView.bottomAnchor, constant: constant),
            self.summaryLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: constant),
            self.summaryLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -constant),
            self.summaryLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
        
        self.stackView.addArrangedSubview(self.nameLabel)
        self.stackView.addArrangedSubview(self.genresLabel)
        self.stackView.addArrangedSubview(self.daysLabel)
        self.stackView.addArrangedSubview(self.timeLabel)
        
        self.stackView.setCustomSpacing(0, after: self.daysLabel)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initialize()
    }
}
