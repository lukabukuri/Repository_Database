//
//  UIViewControllerExtentions.swift
//  Repository_Database
//
//  Created by Luka Bukuri on 24.09.22.
//

import UIKit

extension UIViewController {
    
    func scrollToTop(view: UIView?, navigationController: UINavigationController?) {
        guard let view = view else { return }
        switch view {
        case let scrollView as UIScrollView:
            if scrollView.scrollsToTop == true {
                let expandedBar = (navigationController?.navigationBar.frame.height ?? 64.0 > 44.0)
                let largeTitles = (navigationController?.navigationBar.prefersLargeTitles) ?? false
                let offset: CGFloat = (largeTitles && !expandedBar) ? 52: 0
                scrollView.setContentOffset(CGPoint(x: 0, y: -(scrollView.adjustedContentInset.top + offset)), animated: true)
                
                return
            }
        default:
            break
        }
        
        for subView in view.subviews {
            scrollToTop(view: subView, navigationController: navigationController)
        }
    }
    
    func activityIndicator(show: Bool) {
        
        let tag = 009
        if show {
            let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            indicator.tag = tag
            indicator.style = .large
            indicator.startAnimating()
            indicator.hidesWhenStopped = true
            
            if let indicator = view.viewWithTag(tag) as? UIActivityIndicatorView {
                indicator.removeFromSuperview()
            } else {
                view.addSubview(indicator)
                indicator.translatesAutoresizingMaskIntoConstraints = false
                indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            }
        } else {
            if let indicator = view.viewWithTag(tag) as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
    
}

