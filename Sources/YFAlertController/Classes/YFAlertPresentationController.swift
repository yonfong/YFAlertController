//
//  YFAlertPresentationController.swift
//  YFAlertController
//
//  Created by sky on 2022/10/3.
//

import UIKit

class YFAlertPresentationController: UIPresentationController {
    
    /// 自定义背景蒙版
    var customOverlayView: UIView?
    convenience init(customOverlay: UIView?, presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        self.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        self.customOverlayView = customOverlay
    }
    
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        if let containerV = self.containerView {
            self.overlayView.frame = containerV.bounds
        }
    }
    
    // MARK: - 1.将要开始弹出
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        guard let alertCtl = self.presentedViewController as? YFAlertController else {
            return
        }
        
        if customOverlayView == nil {
            (overlayView as? YFOverlayView)?.configBlurEffectStyle(style: alertCtl.backgroundViewBlurEffectStyle, alpha: alertCtl.backgroundViewAlpha)
        }
        
        // 遮罩的alpha值从0～1变化，UIViewControllerTransitionCoordinator协是一个过渡协调器，当执行模态过渡或push过渡时，可以对视图中的其他部分做动画
        if let transitionCoordinator = self.presentedViewController.transitionCoordinator {
            transitionCoordinator.animate { [weak self] context in
                self?.overlayView.alpha = 1.0
            }
        } else {
            self.overlayView.alpha = 1.0
        }
        alertCtl.delegate?.willPresentAlertController(alertController: alertCtl)
    }
    
    // MARK: - 2.已经弹出
    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        guard let alertCtl = self.presentedViewController as? YFAlertController else {
            return
        }
        
        alertCtl.delegate?.didPresentAlertController(alertController: alertCtl)
    }
    
    // MARK: - 3.即将dismiss
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        
        guard let alertCtl = self.presentedViewController as? YFAlertController else {
            return
        }
        
        // 遮罩的alpha值从1～0变化，UIViewControllerTransitionCoordinator协议执行动画可以保证和转场动画同步
        if let transitionCoordinator = self.presentedViewController.transitionCoordinator {
            transitionCoordinator.animate { [weak self] context in
                self?.overlayView.alpha = 0.0
            }
        } else {
            self.overlayView.alpha = 0.0
        }
        alertCtl.delegate?.willDismissAlertController(alertController: alertCtl)
    }
    // MARK: - 4.已经dismissed
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        
        if completed {
            self.overlayView.removeFromSuperview()
        }
        
        guard let alertCtl = self.presentedViewController as? YFAlertController else {
            return
        }
        alertCtl.delegate?.didDismissAlertController(alertController: alertCtl)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        return self.presentedView?.frame ?? .zero
    }
    

    var _overlayView: UIView?
    private var overlayView: UIView {
        if _overlayView == nil {
            if let customView = customOverlayView {
                _overlayView = customView
            } else {
                _overlayView = YFOverlayView()
            }
            _overlayView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapOverlayView))
            _overlayView!.addGestureRecognizer(tap)
            self.containerView?.insertSubview(_overlayView!, at: 0)
        }
        return _overlayView!
    }
    
    @objc func tapOverlayView() {
        guard let alertCtl = self.presentedViewController as? YFAlertController else {
            return
        }
        
        if alertCtl.tapBackgroundViewDismiss {
            alertCtl.dismiss(animated: true, completion: nil)
        }
    }
}
