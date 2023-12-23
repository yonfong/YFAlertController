//
//  YFAlertController+TransitioningDelegate.swift
//  YFAlertController
//
//  Created by sky on 2022/10/3.
//

import UIKit

extension YFAlertController: UIViewControllerTransitioningDelegate {
    
    // 2.如何弹出的动画
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return YFAlertTransitionAnimator.animation(isPresenting: true, interactor: self.interactor)
    }
    // 3.如何dismissed的动画
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.view.endEditing(true)
        return YFAlertTransitionAnimator.animation(isPresenting: false, interactor: self.interactor)
    }
    // 1.返回一个自定义的UIPresentationController
    // 控制控制器跳转的类,是iOS8新增的一个API，用来控制controller之间的跳转特效，
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return YFAlertPresentationController(customOverlay: customOverlayView, presentedViewController: presented, presenting: presenting)
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}

