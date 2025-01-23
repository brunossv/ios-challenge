//
//  
//  BlockScreenView.swift
//  ios-challange
//
//  Created by Bruno Soares on 22/01/25.
//
//

import Foundation
import UIKit

protocol BlockScreenViewDelegate: AnyObject {
    func tryAgain(_ sender: UIButton)
}

class BlockScreenView: UIView {
    
    private lazy var tryAgainButton: UIButton = {
        let view = UIButton(type: .roundedRect)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("Unlock", for: .normal)
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.tintColor = .white
        
        return view
    }()
    
    weak var delegate: BlockScreenViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    func initialize() {
        self.configureSubviews()
    }
    
    private func configureSubviews() {
        self.backgroundColor = .systemFill
        self.addSubview(self.tryAgainButton)
        
        let height: CGFloat = 46
        let width: CGFloat = 200
        let padding: CGFloat = 15
        NSLayoutConstraint.activate([
            self.tryAgainButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.tryAgainButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            self.tryAgainButton.heightAnchor.constraint(equalToConstant: height),
            self.tryAgainButton.widthAnchor.constraint(equalToConstant: width)
        ])
        
        self.tryAgainButton.addTarget(self, action: #selector(self.tryAgainAction(_:)), for: .touchUpInside)
    }
    
    @objc
    private func tryAgainAction(_ sender: UIButton) {
        self.delegate?.tryAgain(sender)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initialize()
    }
}
