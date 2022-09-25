//
//  UITableViewExtentions.swift
//  Repository_Database
//
//  Created by Luka Bukuri on 23.09.22.
//

import UIKit

extension UITableView {
    
    func registerClass<T: UITableViewCell>(class: T.Type) {
        self.register(T.self, forCellReuseIdentifier: T.identifier)
    }
    
    func deque<T: UITableViewCell>(_ classType: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as! T
    }
    
    func defaultPlaceHolder(show: Bool, status: CustomPlaceHolder? = nil) {
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            let tag = 55
            
            if let view = self.viewWithTag(tag) as? UIStackView {
                view.removeFromSuperview()
            }
            
            if show {
                let defaultImage = UIImageView()
                defaultImage.tintColor = .darkGray
                defaultImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
                defaultImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
                defaultImage.image = status?.icon
                
                let defaultLabel = UILabel()
                defaultLabel.numberOfLines = 2
                defaultLabel.textColor = .darkGray
                defaultLabel.font.withSize(12)
                
                defaultImage.image = status?.icon
                defaultLabel.text = status?.title
                
                
                let stackView = UIStackView()
                stackView.axis  = NSLayoutConstraint.Axis.vertical
                stackView.distribution  = UIStackView.Distribution.equalSpacing
                stackView.alignment = UIStackView.Alignment.center
                
                stackView.spacing = 16.0
                stackView.tag = tag
                stackView.addArrangedSubview(defaultImage)
                stackView.addArrangedSubview(defaultLabel)
                
                self.addSubview(stackView)
                stackView.translatesAutoresizingMaskIntoConstraints = false
                stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
                stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
                
            } else {
                
                if let stack = self.viewWithTag(tag) as? UIStackView {
                    stack.removeFromSuperview()
                }
            }
        }
    }
}

extension UITableViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
}

