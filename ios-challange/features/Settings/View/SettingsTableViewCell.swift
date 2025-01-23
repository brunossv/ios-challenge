//
// 
//  SettingsTableViewCell.swift
//  ios-challange
//
//  Created by Bruno Soares on 21/01/25.
//
//

import Foundation
import UIKit

protocol SettingsTableViewCellDelegate: AnyObject {
    func updateValue(_ value: Bool, for setting: SettingsTableViewCell)
}

class SettingsTableViewCell: UITableViewCell {
    
    private lazy var iconView: UIImageView = {
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
    
    private lazy var switchView: UISwitch = {
        let view = UISwitch()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isOn = false
        
        return view
    }()
    
    var title: String? {
        get { return self.titleLabel.text }
        set { self.titleLabel.text = newValue }
    }
    
    var icon: UIImage? {
        get { return self.iconView.image }
        set { self.iconView.image = newValue }
    }
    
    var isOn: Bool {
        get { return self.switchView.isOn }
        set { self.switchView.isOn = newValue }
    }
    
    weak var delegate: SettingsTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initialize()
    }
    
    func initialize() {
        self.configureSubviews()
    }
    
    private func configureSubviews() {
        self.contentView.addSubview(self.iconView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.switchView)
        
        let constant: CGFloat = 10
        NSLayoutConstraint.activate([
            self.iconView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: constant),
            self.iconView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: constant),
            self.iconView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -constant),
            self.iconView.heightAnchor.constraint(equalToConstant: 25),
            self.iconView.widthAnchor.constraint(equalToConstant: 25)
        ])
        NSLayoutConstraint.activate([
            self.titleLabel.leftAnchor.constraint(equalTo: self.iconView.rightAnchor, constant: constant),
            self.titleLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
        NSLayoutConstraint.activate([
            self.switchView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.switchView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -constant)
        ])
        
        self.switchView.addTarget(self, action: #selector(self.updateValue(_:)), for: .touchUpInside)
    }
    
    @objc
    func updateValue(_ sender: UISwitch) {
        self.delegate?.updateValue(sender.isOn, for: self)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initialize()
    }
}
