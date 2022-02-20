//
//  Extensions.swift
//  MVVMCoordinator
//
//  Created by Max Bystryk on 16.02.2022.
//

import UIKit

public extension UIViewController {
    ///If fillSuperview is set to false, child view layout should be configured manually.
    func add(_ child: UIViewController, fillSuperview: Bool = true) {
        add(child, in: view, fillSuperview: fillSuperview)
    }
    
    ///If fillSuperview is set to false, child view layout should be configured manually.
    func add(_ child: UIViewController, in containerView: UIView, fillSuperview: Bool = true) {
        // Just to be sure the container is withing the VC view hierarchy
        guard containerView.isDescendant(of: self.view) else { return }
        
        addChild(child)
        containerView.addSubview(child.view)
        if fillSuperview { child.view.fillSuperview() }
        child.didMove(toParent: self)
    }
    
    func remove() {
        // Just to be safe, we check that this view controller
        // is actually added to a parent before removing it.
        guard parent != nil else {
            return
        }
        
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}

extension UIView {
    func fillSuperview() {
        guard let superview = self.superview else { return }
        translatesAutoresizingMaskIntoConstraints = superview.translatesAutoresizingMaskIntoConstraints
        if translatesAutoresizingMaskIntoConstraints {
            autoresizingMask = [.flexibleWidth, .flexibleHeight]
            frame = superview.bounds
        } else {
            topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
            bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
            leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
            rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
        }
    }
}

public protocol NibLoadable: UIView {}

public extension NibLoadable {
    static func fromNib<T: UIView>(_ index: Int = 0) -> T  {
        let nibBundle = Bundle(for: Self.self).loadNibNamed(String(describing: self), owner: nil, options: nil)
        return nibBundle![index] as! T
    }
}
