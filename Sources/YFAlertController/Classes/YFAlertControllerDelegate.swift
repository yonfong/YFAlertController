//
//  YFAlertControllerDelegate.swift
//  YFAlertController
//
//  Created by sky on 2022/10/3.
//

import UIKit


public protocol YFAlertControllerDelegate: AnyObject {
    
}

extension YFAlertControllerDelegate {
    
    /// 将要present
    func willPresentAlertController(alertController: YFAlertController) {
        
    }
    /// 已经present
    func didPresentAlertController(alertController: YFAlertController) {
        
    }
    /// 将要dismiss
    func willDismissAlertController(alertController: YFAlertController) {
        
    }
    /// 已经dismiss
    func didDismissAlertController(alertController: YFAlertController) {
        
    }
}
