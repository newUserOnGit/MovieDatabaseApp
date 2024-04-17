//
//  PushTrasistion.swift
//  MovieBase
//
//  Created by Alexander on 28.03.2024.
//

import UIKit

open class PushTransition: NSObject {
    public var animator: Animator?
    public var isAnimated: Bool = true
    public var completionHandler: (() -> Void)?

    weak public var viewController: UIViewController?

    public init(animator: Animator? = nil, isAnimated: Bool = true) {
        self.animator = animator
        self.isAnimated = isAnimated
    }
}

extension PushTransition: Transition {
    public func close(_ viewController: UIViewController, animated: Bool?) {
        self.viewController?.navigationController?.popViewController(animated: animated ?? isAnimated)
    }

    public func open(_ viewController: UIViewController) {
        self.viewController?.navigationController?.delegate = self
        self.viewController?.navigationController?.pushViewController(viewController, animated: isAnimated)
    }

    public func close(_ viewController: UIViewController) {
        self.viewController?.navigationController?.popViewController(animated: isAnimated)
    }
    
    public func closeChilds(animated: Bool = true) {
        guard let vc = self.viewController else { return }
        vc.navigationController?.popToViewController(vc, animated: animated)
    }
}


extension PushTransition: UINavigationControllerDelegate {

    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        completionHandler?()
    }

    public func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let animator = animator else {
            return nil
        }
        if operation == .push {
            animator.isPresenting = true
            return animator
        } else {
            animator.isPresenting = false
            return animator
        }
    }
}


