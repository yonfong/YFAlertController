//
//  YFInteractiveTransition.swift
//  YFAlertController
//
//  Created by sky on 2022/10/3.
//

import UIKit

class YFPercentTransitionInteractor: UIPercentDrivenInteractiveTransition {
    // If the interactive transition was started
    var hasStarted = false

    // If the interactive transition
    var shouldFinish = false

    // The view controller containing the views
    // with attached gesture recognizers weak
    weak var alertCtl: YFAlertController?

    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        guard let alertCtl = alertCtl else { return }

        guard let progress = calculateProgress(sender: sender) else { return }
        switch sender.state {
        case .began:
            hasStarted = true
            alertCtl.dismiss(animated: true, completion: nil)
        case .changed:
            shouldFinish = progress > 0.3
            update(progress)
        case .cancelled:
            hasStarted = false
            cancel()
        case .ended:
            hasStarted = false
            completionSpeed = 0.55
            shouldFinish ? finish() : cancel()
        default:
            break
        }
    }
    
    deinit {
        debugPrint("\(self.description) deinit")
    }
}

extension YFPercentTransitionInteractor {
    
    /*!
     Translates the pan gesture recognizer position to the progress percentage
     - parameter sender: A UIPanGestureRecognizer
     - returns: Progress
     */
    func calculateProgress(sender: UIPanGestureRecognizer) -> CGFloat? {
        guard let alertCtl = alertCtl else { return nil }

        // http://www.thorntech.com/2016/02/ios-tutorial-close-modal-dragging/
        let translation = sender.translation(in: alertCtl.view)
        let verticalMovement: CGFloat = translation.y / alertCtl.view.bounds.height

        var downwardMovement: Float = 0.0
        if alertCtl.animationType == .fromTop && alertCtl.preferredStyle == .actionSheet {
            downwardMovement = fmaxf(Float(-verticalMovement), 0.0)
        } else {
            downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        }
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        
        let progress = CGFloat(downwardMovementPercent)

        return progress
    }
}
