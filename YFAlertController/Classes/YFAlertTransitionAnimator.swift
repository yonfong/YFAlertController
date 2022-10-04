//
//  YFAlertAnimation.swift
//  YFAlertController
//
//  Created by sky on 2022/10/3.
//

import UIKit

class YFAlertTransitionAnimator: NSObject {
    
    var interactor: YFPercentTransitionInteractor
    var transitionDuration: TimeInterval = 0.25
    
    private var isPresenting: Bool = false
    
    public class func animation(isPresenting: Bool, interactor: YFPercentTransitionInteractor) -> YFAlertTransitionAnimator {
        let alertAnimation = YFAlertTransitionAnimator(isPresenting: isPresenting, interactor: interactor)
        return alertAnimation
    }
    
    private init(isPresenting: Bool, interactor: YFPercentTransitionInteractor) {
        self.interactor = interactor
        super.init()
        self.isPresenting = isPresenting
    }
    
    deinit {
        debugPrint("\(self.description) deinit")
    }
}

extension YFAlertTransitionAnimator: UIViewControllerAnimatedTransitioning {
    
    // 1.动画时长
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }
    
    // 2.如何执行动画
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if self.isPresenting {
            self.presentAnimationTransition(using: transitionContext)
        } else { // 退出动画
            self.dismissAnimationTransition(using: transitionContext)
        }
    }
}

extension YFAlertTransitionAnimator {
    private func presentAnimationTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let alertCtl = transitionContext.viewController(forKey: .to) as? YFAlertController else { return }
        
        switch alertCtl.animationType {
        case .fromBottom:
            self.raiseUpWhenPresent(for: alertCtl, using: transitionContext)
        case .fromRight:
            self.fromRightWhenPresent(for: alertCtl, using: transitionContext)
        case .fromTop:
            self.dropDownWhenPresent(for: alertCtl, using: transitionContext)
        case .fromLeft:
            self.fromLeftWhenPresent(for: alertCtl, using: transitionContext)
        case .fade:
            self.alphaWhenPresent(for: alertCtl, using: transitionContext)
        case .expand:
            self.expandWhenPresent(for: alertCtl, using: transitionContext)
        case .shrink:
            self.shrinkWhenPresent(for: alertCtl, using: transitionContext)
        case .none:
            self.noneWhenPresent(for: alertCtl, using: transitionContext)
        default:
            self.noneWhenPresent(for: alertCtl, using: transitionContext)
            break
        }
    }
    private func dismissAnimationTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let alertCtl = transitionContext.viewController(forKey: .from) as? YFAlertController else { return }
        
        if interactor.hasStarted || interactor.shouldFinish {
            self.dismissInteractive(for: alertCtl, using: transitionContext)
            return
        }
        
        switch alertCtl.animationType {
        case .fromBottom:
            self.dismissCorrespondingRaiseUp(for: alertCtl, using: transitionContext)
        case .fromRight:
            self.dismissCorrespondingFromRight(for: alertCtl, using: transitionContext)
        case .fromTop:
            self.dismissCorrespondingDropDown(for: alertCtl, using: transitionContext)
        case .fromLeft:
            self.dismissCorrespondingFromLeft(for: alertCtl, using: transitionContext)
        case .fade:
            self.dismissCorrespondingAlpha(for: alertCtl, using: transitionContext)
        case .expand:
            self.dismissCorrespondingExpand(for: alertCtl, using: transitionContext)
        case .shrink:
            self.dismissCorrespondingShrink(for: alertCtl, using: transitionContext)
        case .none:
            self.dismissCorrespondingNone(for: alertCtl, using: transitionContext)
        default:
            self.dismissInteractive(for: alertCtl, using: transitionContext)
            break
        }
    }
    
    
    // 从底部弹出的present动画
    private func raiseUpWhenPresent(for alertController: YFAlertController,
                                    using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        // 将alertController的view添加到containerView上
        containerView.addSubview(alertController.view)
        // 标记需要刷新布局
        containerView.setNeedsLayout()
        // 在有标记刷新布局的情况下立即布局，这行代码很重要，
        // 第一：立即布局会立即调用YFAlertController的viewWillLayoutSubviews的方法，
        // 第二：立即布局后可以获取到alertController.view的frame
        containerView.layoutIfNeeded()
        
        // 这3行代码不能放在layoutIfNeeded()之前，如果放在之前，
        // layoutIfNeeded()强制布局后会将以下设置的frame覆盖
        var controlViewFrame = alertController.view.frame
        controlViewFrame.origin.y = YFAlertConfig.screenHeight
        alertController.view.frame = controlViewFrame
        // (0.0, 667.0, 375.0, 0.0)
        
        let duration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            var controlViewFrame = alertController.view.frame
            if alertController.preferredStyle == .actionSheet {
                controlViewFrame.origin.y = YFAlertConfig.screenHeight-controlViewFrame.size.height
            } else {
                controlViewFrame.origin.y = (YFAlertConfig.screenHeight-controlViewFrame.size.height) / 2.0
                self.offSetCenter(alertController: alertController)
            }
            alertController.view.frame = controlViewFrame
        }, completion: { finished in
            transitionContext.completeTransition(finished)
            alertController.layoutAlertControllerView()
        })
    }
    
    // 从底部弹出对应的dismiss动画
    private func dismissCorrespondingRaiseUp(for alertController: YFAlertController,
                                             using transitionContext: UIViewControllerContextTransitioning) {
        
        let duration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: {
            var controlViewFrame = alertController.view.frame
           
            controlViewFrame.origin.y = YFAlertConfig.screenHeight
            alertController.view.frame = controlViewFrame
        }, completion: { finished in
            transitionContext.completeTransition(finished)
        })
    }
    // 从右边弹出的present动画
    private func fromRightWhenPresent(for alertController: YFAlertController,
                                      using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        // 将alertController的view添加到containerView上
        containerView.addSubview(alertController.view)
        // 标记需要刷新布局
        containerView.setNeedsLayout()
        // 在有标记刷新布局的情况下立即布局，这行代码很重要，
        // 第一：立即布局会立即调用YFAlertController的viewWillLayoutSubviews的方法，
        // 第二：立即布局后可以获取到alertController.view的frame
        containerView.layoutIfNeeded()
        
        // 这3行代码不能放在layoutIfNeeded()之前，如果放在之前，
        // layoutIfNeeded()强制布局后会将以下设置的frame覆盖
        var controlViewFrame = alertController.view.frame
        controlViewFrame.origin.x = YFAlertConfig.screenWidth
        alertController.view.frame = controlViewFrame
        
        if alertController.preferredStyle == .alert {
            self.offSetCenter(alertController: alertController)
        }
        
        let duration = self.transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            var controlViewFrame = alertController.view.frame
            if alertController.preferredStyle == .actionSheet {
                controlViewFrame.origin.x = YFAlertConfig.screenWidth-controlViewFrame.size.width
            } else {
                controlViewFrame.origin.x = (YFAlertConfig.screenWidth-controlViewFrame.size.width) / 2.0
            }
            alertController.view.frame = controlViewFrame
        }, completion: { finished in
            transitionContext.completeTransition(finished)
            alertController.layoutAlertControllerView()
        })
    }
    // 从右边弹出对应的dismiss动画
    private func dismissCorrespondingFromRight(for alertController: YFAlertController,
                                               using transitionContext: UIViewControllerContextTransitioning) {
        
        let duration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: {
            var controlViewFrame = alertController.view.frame
           
            controlViewFrame.origin.x = YFAlertConfig.screenWidth
            alertController.view.frame = controlViewFrame
        }, completion: { finished in
            transitionContext.completeTransition(finished)
        })
    }
    // 从左边弹出的present动画
    private func fromLeftWhenPresent(for alertController: YFAlertController,
                                     using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        // 将alertController的view添加到containerView上
        containerView.addSubview(alertController.view)
        // 标记需要刷新布局
        containerView.setNeedsLayout()
        // 在有标记刷新布局的情况下立即布局，这行代码很重要，
        // 第一：立即布局会立即调用YFAlertController的viewWillLayoutSubviews的方法，
        // 第二：立即布局后可以获取到alertController.view的frame
        containerView.layoutIfNeeded()
        
        // 这3行代码不能放在layoutIfNeeded()之前，如果放在之前，
        // layoutIfNeeded()强制布局后会将以下设置的frame覆盖
        var controlViewFrame = alertController.view.frame
        controlViewFrame.origin.x = -controlViewFrame.size.width
        alertController.view.frame = controlViewFrame
        
        if alertController.preferredStyle == .alert {
            self.offSetCenter(alertController: alertController)
        }
        
        let duration = self.transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            
            var controlViewFrame = alertController.view.frame
            if alertController.preferredStyle == .actionSheet {
                controlViewFrame.origin.x = 0
            } else {
                controlViewFrame.origin.x = (YFAlertConfig.screenWidth-controlViewFrame.size.width) / 2.0
            }
            alertController.view.frame = controlViewFrame
        }, completion: { finished in
            transitionContext.completeTransition(finished)
            alertController.layoutAlertControllerView()
        })
    }
    // 从左边弹出对应的dismiss动画
    private func dismissCorrespondingFromLeft(for alertController: YFAlertController,
                                              using transitionContext: UIViewControllerContextTransitioning) {
        
        let duration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: {
            var controlViewFrame = alertController.view.frame
           
            controlViewFrame.origin.x = -controlViewFrame.size.width
            alertController.view.frame = controlViewFrame
        }, completion: { finished in
            transitionContext.completeTransition(finished)
        })
    }
    // 从顶部弹出的present动画
    private func dropDownWhenPresent(for alertController: YFAlertController,
                                     using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        // 将alertController的view添加到containerView上
        containerView.addSubview(alertController.view)
        // 标记需要刷新布局
        containerView.setNeedsLayout()
        // 在有标记刷新布局的情况下立即布局，这行代码很重要，
        // 第一：立即布局会立即调用YFAlertController的viewWillLayoutSubviews的方法，
        // 第二：立即布局后可以获取到alertController.view的frame
        containerView.layoutIfNeeded()
        
        // 这3行代码不能放在layoutIfNeeded()之前，如果放在之前，
        // layoutIfNeeded()强制布局后会将以下设置的frame覆盖
        var controlViewFrame = alertController.view.frame
        controlViewFrame.origin.y = -controlViewFrame.size.height
        alertController.view.frame = controlViewFrame
        
        let duration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            
            var controlViewFrame = alertController.view.frame
            if alertController.preferredStyle == .actionSheet {
                controlViewFrame.origin.y = 0
            } else {
                controlViewFrame.origin.y = (YFAlertConfig.screenHeight-controlViewFrame.size.height) / 2.0
                self.offSetCenter(alertController: alertController)
            }
            alertController.view.frame = controlViewFrame
        }, completion: { finished in
            transitionContext.completeTransition(finished)
            alertController.layoutAlertControllerView()
        })
    }
    // 从顶部弹出对应的dismiss动画
    private func dismissCorrespondingDropDown(for alertController: YFAlertController,
                                              using transitionContext: UIViewControllerContextTransitioning) {
        let duration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: {
            var controlViewFrame = alertController.view.frame
           
            controlViewFrame.origin.y = -controlViewFrame.size.height
            alertController.view.frame = controlViewFrame
        }, completion: { finished in
            transitionContext.completeTransition(finished)
        })
    }
    
    // alpha值从0到1变化的present动画
    private func alphaWhenPresent(for alertController: YFAlertController,
                                  using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        // 将alertController的view添加到containerView上
        containerView.addSubview(alertController.view)
        // 标记需要刷新布局
        containerView.setNeedsLayout()
        // 在有标记刷新布局的情况下立即布局，这行代码很重要，
        // 第一：立即布局会立即调用YFAlertController的viewWillLayoutSubviews的方法，
        // 第二：立即布局后可以获取到alertController.view的frame
        containerView.layoutIfNeeded()
        
        alertController.view.alpha = 0
        
        let duration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            
            self.offSetCenter(alertController: alertController)
            alertController.view.alpha = 1.0
        }, completion: { finished in
            
            transitionContext.completeTransition(finished)
            alertController.layoutAlertControllerView()
        })
    }
    // alpha值从0到1变化对应的的dismiss动画
    private func dismissCorrespondingAlpha(for alertController: YFAlertController,
                                           using transitionContext: UIViewControllerContextTransitioning) {
        
        let duration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: {
            alertController.view.alpha = 0.0
        }, completion: { finished in
            transitionContext.completeTransition(finished)
        })
    }
    
    // 发散的prensent动画
    private func expandWhenPresent(for alertController: YFAlertController,
                                   using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        // 将alertController的view添加到containerView上
        containerView.addSubview(alertController.view)
        
        // 标记需要刷新布局
        containerView.setNeedsLayout()
        // 在有标记刷新布局的情况下立即布局，这行代码很重要，
        // 第一：立即布局会立即调用YFAlertController的viewWillLayoutSubviews的方法，
        // 第二：立即布局后可以获取到alertController.view的frame
        containerView.layoutIfNeeded()
        
        alertController.view.transform = CGAffineTransform.init(scaleX: 0.9, y: 0.9)
        alertController.view.alpha = 0.0
        
        let duration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.offSetCenter(alertController: alertController)
            alertController.view.alpha = 1.0
        }, completion: { finished in
            
            transitionContext.completeTransition(finished)
            alertController.layoutAlertControllerView()
        })
    }
    // 发散对应的dismiss动画
    private func dismissCorrespondingExpand(for alertController: YFAlertController,
                                            using transitionContext: UIViewControllerContextTransitioning) {
        
        let duration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: {
            alertController.view.transform = .identity
            alertController.view.alpha = 0.0
        }, completion: { finished in
            transitionContext.completeTransition(finished)
        })
    }
    
    // 收缩的present动画
    private func shrinkWhenPresent(for alertController: YFAlertController,
                                   using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        // 将alertController的view添加到containerView上
        containerView.addSubview(alertController.view)
        
        // 标记需要刷新布局
        containerView.setNeedsLayout()
        // 在有标记刷新布局的情况下立即布局，这行代码很重要，
        // 第一：立即布局会立即调用YFAlertController的viewWillLayoutSubviews的方法，
        // 第二：立即布局后可以获取到alertController.view的frame
        containerView.layoutIfNeeded()
        
        alertController.view.transform = CGAffineTransform.init(scaleX: 1.1, y: 1.1)
        alertController.view.alpha = 0.0
        
        let duration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            
            self.offSetCenter(alertController: alertController)
            alertController.view.transform = .identity
            alertController.view.alpha = 1.0
        }, completion: { finished in
            
            transitionContext.completeTransition(finished)
            alertController.layoutAlertControllerView()
        })
    }
    // 收缩对应的的dismiss动画
    private func dismissCorrespondingShrink(for alertController: YFAlertController,
                                            using transitionContext: UIViewControllerContextTransitioning) {
        
        // 与发散对应的dismiss动画相同
        self.dismissCorrespondingExpand(for: alertController, using: transitionContext)
    }
    
    // 无动画
    private func noneWhenPresent(for alertController: YFAlertController,
                                 using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        // 将alertController的view添加到containerView上
        containerView.addSubview(alertController.view)
        
        transitionContext.completeTransition(transitionContext.isAnimated)
    }
    
    // 无动画
    private func dismissCorrespondingNone(for alertController: YFAlertController,
                                          using transitionContext: UIViewControllerContextTransitioning) {
        transitionContext.completeTransition(transitionContext.isAnimated)
    }
    
    // 手势退出
    private func dismissInteractive(for alertController: YFAlertController,
                                    using transitionContext: UIViewControllerContextTransitioning) {
        
        UIView.animate(withDuration: 0.32, delay: 0.0, options: [.beginFromCurrentState], animations: {
            var offsetHeight: CGFloat = alertController.view.bounds.size.height
            if offsetHeight < 300 {
                offsetHeight = 300
            }
            offsetHeight = -offsetHeight
            if alertController.animationType == .fromTop && alertController.preferredStyle == .actionSheet {
                offsetHeight = -offsetHeight
            }
            if alertController.preferredStyle == .alert {
                offsetHeight = -(YFAlertConfig.screenHeight-alertController.view.bounds.size.height)/2
            }
            alertController.view.bounds.origin = CGPoint(x: 0, y: offsetHeight)
            alertController.view.alpha = 0.0
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
    private func offSetCenter(alertController: YFAlertController) {
        if !alertController.offsetForAlert.equalTo(.zero) {
            var controlViewCenter: CGPoint = alertController.view.center
            controlViewCenter.x = YFAlertConfig.screenWidth/2 + alertController.offsetForAlert.x
            controlViewCenter.y = YFAlertConfig.screenHeight/2 + alertController.offsetForAlert.y
            alertController.view.center = controlViewCenter
        }
    }
}
