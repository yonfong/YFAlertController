//
//  ViewController+background.swift
//  YFAlertController
//
//  Created by yonfong on 10/03/2022.
//  Copyright © 2020 yonfong. All rights reserved.
//

import UIKit
import YFAlertController

extension ViewController {
    
    func background(appearanceStyle: UIBlurEffect.Style?) {
        
        let alertController = YFAlertController.alertController(title: "我是主标题", message: "我是副标题", preferredStyle: .actionSheet)
        alertController.needDialogBlur = lookBlur
        let action1 = YFAlertAction.action(withTitle: "Default", style: .default) { (action) in
            print("点击了Default")
        }
        let action2 = YFAlertAction.action(withTitle: "Destructive", style: .destructive) { (action) in
            print("点击了Destructive")
        }
        let action3 = YFAlertAction.action(withTitle: "Cancel", style: .cancel) { (action) in
            print("点击了Cancel------")
        }
        
        alertController.addAction(action: action1)
        alertController.addAction(action: action3)
        alertController.addAction(action: action2)
        if customBlur {
            alertController.customOverlayView = CustomOverlayView()
        } else {
            let alpha = appearanceStyle != nil ? 1.0 : 0.5
            alertController.setBackgroundViewBlurEffectStyle(style: appearanceStyle, alpha: alpha)
        }
        self.present(alertController, animated: true, completion: nil)
        
    }
}
