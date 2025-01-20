//
//  SeriesCastTableViewCell.swift
//  ios-challange
//
//  Created by Bruno Soares on 17/01/25.
//
import UIKit

class SeriesCastTableViewCell: UITableViewCell {
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = 5
        view.distribution = .fillProportionally
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initialize()
    }
    
    func initialize() {
        self.configureSubviews()
    }
    
    func setupCollection(of items: Int, _ handler: (_ item: Int) -> (image: String,caster: String,actor: String)) {
        self.stackView.arrangedSubviews.forEach({ $0.removeFromSuperview()})
        
        for item in 0..<items {
            let view = SeriesCastView()
            let (image, caster, actor) = handler(item)
            view.casterString = caster
            view.actorString = actor
            Task {
                view.caster = try? await Services().loadImage(image)
            }
            self.stackView.addArrangedSubview(view)
        }
        self.scrollView.layoutIfNeeded()
        self.layoutIfNeeded()
    }
    
    private func configureSubviews() {
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.contentView.addSubview(self.scrollView)
        self.scrollView.addSubview(self.stackView)
        
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.scrollView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            self.scrollView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.stackView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.stackView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor),
            self.stackView.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor),
            self.stackView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor)
        ])
    }
}
