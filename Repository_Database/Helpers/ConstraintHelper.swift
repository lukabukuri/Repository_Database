//
//  ConstraintHelper.swift
//  Repository_Database
//
//  Created by Luka Bukuri on 22.09.22.
//

import UIKit

extension UIView {
    @discardableResult
    func constrain(with: UIView, addAsSubview: Bool = false) -> ConstraintHelper {
        if addAsSubview {
            if let with = with as? UIStackView {
                with.addArrangedSubview(self)
            } else {
                with.addSubview(self)
            }
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        return ConstraintHelper(me:self, it: with)
    }
}

struct ConstraintHelper {
    private let me: UIView
    private let it: UIView
    private let lastContstraint: ConstraintReference
    
    init(me: UIView, it: UIView) {
        self.init(me: me, it: it, lastConstraint: ConstraintReference())
    }
    
    func getView() -> UIView {
        me
    }
    
    private init(me: UIView, it: UIView, lastConstraint: ConstraintReference) {
        self.me = me
        self.it = it
        self.lastContstraint = lastConstraint
    }
        
    func changeTarget(_ target: UIView) -> ConstraintHelper{
        ConstraintHelper(me: self.me, it: target, lastConstraint: self.lastContstraint)
    }
    
    @discardableResult
    func getConstraint(constraint: inout NSLayoutConstraint?) -> Self {
        constraint = lastContstraint.value
        return self
    }
    
    //MARK: - Size constants
    @discardableResult
    func setConstantHeight(_ value: CGFloat = 0) -> Self {
        lastContstraint.save(me.heightAnchor.constraint(equalToConstant: value))
        return self
    }
    
    @discardableResult
    func setMinHeight(_ value: CGFloat) -> Self {
        lastContstraint.save(me.heightAnchor.constraint(greaterThanOrEqualToConstant: value))
        return self
    }
    
    @discardableResult
    func setConstantWidth(_ value: CGFloat = 0) -> Self {
        lastContstraint.save(me.widthAnchor.constraint(equalToConstant: value))
        return self
    }
    
    @discardableResult
    func setMinHWidth(_ value: CGFloat) -> Self {
        lastContstraint.save(me.widthAnchor.constraint(greaterThanOrEqualToConstant: value))
        return self
    }
    
    //MARK: -  Horizontal side alignments
    @discardableResult
    func myLeftWithItsLeft(_ value: CGFloat = 0) -> Self {
        lastContstraint.save(me.leftAnchor.constraint(equalTo: it.leftAnchor, constant: value))
        return self
    }
    
    @discardableResult
    func setMaxWidth(_ value: CGFloat) -> Self {
        lastContstraint.save(me.widthAnchor.constraint(lessThanOrEqualToConstant: value))
        return self
    }
    
    @discardableResult
    func myLeftWithItsRight(_ value: CGFloat = 0) -> Self {
        lastContstraint.save(me.leftAnchor.constraint(equalTo: it.rightAnchor, constant: value))
        return self
    }
    
    @discardableResult
    func myRightWithItsLeft(_ value: CGFloat = 0) -> Self {
        lastContstraint.save(me.rightAnchor.constraint(equalTo: it.leftAnchor, constant: -value))
        return self
    }
    
    @discardableResult
    func myRightWithItsRight(_ value: CGFloat = 0) -> Self {
        lastContstraint.save(me.rightAnchor.constraint(equalTo: it.rightAnchor, constant: -value))
        return self
    }
    
    //MARK: -  Vertical side alignments
    @discardableResult
    func myTopWithItsTop(_ value: CGFloat = 0) -> Self {
        lastContstraint.save(me.topAnchor.constraint(equalTo: it.topAnchor, constant: value))
        return self
    }
    
    @discardableResult
    func myTopWithItsBottom(_ value: CGFloat = 0) -> Self {
        lastContstraint.save(me.topAnchor.constraint(equalTo: it.bottomAnchor, constant: value))
        return self
    }
    
    @discardableResult
    func myBottomWithItsTop(_ value: CGFloat = 0) -> Self {
        lastContstraint.save(me.bottomAnchor.constraint(equalTo: it.topAnchor, constant: value))
        return self
    }
    
    @discardableResult
    func myBottomWithItsBottom(_ value: CGFloat = 0) -> Self {
        lastContstraint.save(me.bottomAnchor.constraint(equalTo: it.bottomAnchor, constant: -value))
        return self
    }
    
    //MARK: -  Center alignments
    @discardableResult
    func equalItscenterX() -> Self {
        lastContstraint.save(me.centerXAnchor.constraint(equalTo: it.centerXAnchor))
        return self
    }
    
    @discardableResult
    func equalItscenterY() -> Self {
        lastContstraint.save(me.centerYAnchor.constraint(equalTo: it.centerYAnchor))
        return self
    }
    
    //MARK: -  Size matching
    @discardableResult
    func equalItsWidth() -> Self {
        lastContstraint.save(me.widthAnchor.constraint(equalTo: it.widthAnchor))
        return self
    }
    
    @discardableResult
    func equalItsHeight() -> Self {
        lastContstraint.save(me.heightAnchor.constraint(equalTo: it.heightAnchor))
        return self
    }
    
    private class ConstraintReference {
        var value:NSLayoutConstraint?
        
        func save(_ constraint:NSLayoutConstraint, activate: Bool = true) {
            if(activate){
                constraint.isActive = true
            }
            value = constraint
        }
    }
}
