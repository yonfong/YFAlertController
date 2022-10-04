//
//  ViewController+Sheet.swift
//  YFAlertController
//
//  Created by yonfong on 10/03/2022.
//  Copyright © 2020 yonfong. All rights reserved.
//

import UIKit
import YFAlertController

extension ViewController {
    
    // MARK: ======== YFAlertControllerStyleActionSheet样式示例  ========
    // 示例1:actionSheet的默认动画样式(从底部弹出，有取消按钮)
    func actionSheetTest1 () {
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
        if customBlur {
            alertController.customOverlayView = CustomOverlayView()
        }
        alertController.addAction(action: action1)
        alertController.addAction(action: action3) // 取消按钮一定排在最底部
        alertController.addAction(action: action2)
        self.present(alertController, animated: true, completion: nil)
    }
    // 示例2:actionSheet的默认动画(从底部弹出,无取消按钮)
    func actionSheetTest2 () {
        let alertController = YFAlertController.alertController(title: "我是主标题", message: "我是副标题", preferredStyle: .actionSheet)
        alertController.needDialogBlur = lookBlur
        let action1 = YFAlertAction.action(withTitle: "Default", style: .default) { (action) in
            print("点击了Default")
        }
        let action2 = YFAlertAction.action(withTitle: "Destructive", style: .destructive) { (action) in
            print("点击了Destructive")
        }
        alertController.addAction(action: action1)
        alertController.addAction(action: action2)
        if customBlur {
            alertController.customOverlayView = CustomOverlayView()
        }
        self.present(alertController, animated: true, completion: nil)
    }
    // 示例3:actionSheet从顶部弹出(无标题)
    func actionSheetTest3 () {
        let alertController = YFAlertController.alertController(title: nil, message: nil, preferredStyle: .actionSheet, animationType: .fromTop)
        let action1 = YFAlertAction.action(withTitle: "第1个", style: .default) { (action) in
            print("点击了第1个")
        }
        let action2 = YFAlertAction.action(withTitle: "第2个", style: .destructive) { (action) in
            print("点击了第2个")
        }
        let action3 = YFAlertAction.action(withTitle: "第3个", style: .cancel) { (action) in
            print("点击了第3个")
        }
        if customBlur {
            alertController.customOverlayView = CustomOverlayView()
        }
        alertController.addAction(action: action1)
        alertController.addAction(action: action2)
        alertController.addAction(action: action3)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // 示例4:actionSheet从顶部弹出(有标题)
    func actionSheetTest4 () {
        let alertController = YFAlertController.alertController(title: nil, message: "我是副标题", preferredStyle: .actionSheet, animationType: .fromTop)
        let action1 = YFAlertAction.action(withTitle: "第1个", style: .default) { (action) in
            print("点击了第1个")
        }
        let action2 = YFAlertAction.action(withTitle: "第2个", style: .destructive) { (action) in
            print("点击了第2个")
        }
        let action3 = YFAlertAction.action(withTitle: "第3个", style: .cancel) { (action) in
            print("点击了第3个")
        }
        if customBlur {
            alertController.customOverlayView = CustomOverlayView()
        }
        alertController.addAction(action: action1)
        alertController.addAction(action: action2)
        alertController.addAction(action: action3)
        self.present(alertController, animated: true, completion: nil)
    }
    // 示例5:actionSheet水平排列（有取消按钮）
    func actionSheetTest5 () {
        let alertController = YFAlertController.alertController(title: "我是主标题", message: "我是副标题", preferredStyle: .actionSheet, animationType: .default)
        alertController.actionAxis = .horizontal
        let action1 = YFAlertAction.action(withTitle: "第1个", style: .default) { (action) in
            print("点击了第1个")
        }
        // YFAlertActionStyleDestructive默认文字为红色(可修改)
        let action2 = YFAlertAction.action(withTitle: "第2个", style: .destructive) { (action) in
            print("点击了第2个")
        }
        let action3 = YFAlertAction.action(withTitle: "第3个", style: .default) { (action) in
            print("点击了第3个")
        }
        let action4 = YFAlertAction.action(withTitle: "第4个", style: .default) { (action) in
            print("点击了第4个")
        }
        let action5 = YFAlertAction.action(withTitle: "取消", style: .cancel) { (action) in
            print("点击了cancel")
        }
        if customBlur {
            alertController.customOverlayView = CustomOverlayView()
        }
        alertController.addAction(action: action1)
        alertController.addAction(action: action2)
        alertController.addAction(action: action3)
        alertController.addAction(action: action4)
        alertController.addAction(action: action5)
        self.present(alertController, animated: true, completion: nil)
    }
    // 示例6:actionSheet 水平排列（无取消按钮）
    func actionSheetTest6 () {
        
        let alertController = YFAlertController.alertController(title: "我是主标题", message: "我是副标题", preferredStyle: .actionSheet, animationType: .default)
        alertController.actionAxis = .horizontal
        let action1 = YFAlertAction.action(withTitle: "第1个", style: .default) { (action) in
            print("点击了第1个")
        }
        // YFAlertActionStyleDestructive默认文字为红色(可修改)
        
        let action2 = YFAlertAction.action(withTitle: "第2个", style: .destructive) { (action) in
            print("点击了第2个")
        }
        let action3 = YFAlertAction.action(withTitle: "第3个", style: .default) { (action) in
            print("点击了第3个")
        }
        let action4 = YFAlertAction.action(withTitle: "第4个", style: .default) { (action) in
            print("点击了第4个")
        }
        if customBlur {
            alertController.customOverlayView = CustomOverlayView()
        }
        alertController.addAction(action: action1)
        alertController.addAction(action: action2)
        alertController.addAction(action: action3)
        alertController.addAction(action: action4)
        self.present(alertController, animated: true, completion: nil)
    }
    // 示例7:actionSheet action上有图标
    func actionSheetTest7 () {
        
        let alertController = YFAlertController.alertController(title: nil, message: nil, preferredStyle: .actionSheet, animationType: .default)
        let action1 = YFAlertAction.action(withTitle: "视频通话", style: .default) { (action) in
            print("点击了‘视频通话’")
        }
        action1.image = UIImage.init(named: "video")
        action1.imageTitleSpacing = 5
        
        let action2 = YFAlertAction.action(withTitle: "语音通话", style: .default) { (action) in
            print("点击了‘语音通话’")
        }
        action2.image = UIImage.init(named: "telephone")
        action2.imageTitleSpacing = 5
        
        let action3 = YFAlertAction.action(withTitle: "取消", style: .cancel) { (action) in
            print("点击了第3个")
        }
        if customBlur {
            alertController.customOverlayView = CustomOverlayView()
        }
        alertController.addAction(action: action1)
        alertController.addAction(action: action2)
        alertController.addAction(action: action3)
        self.present(alertController, animated: true, completion: nil)
    }
    // 示例8:actionSheet 模拟多分区样式
    func actionSheetTest8 () {
        
        let alertController = YFAlertController.alertController(title: "我是主标题", message: "我是副标题", preferredStyle: .actionSheet, animationType: .default)
        let action1 = YFAlertAction.action(withTitle: "第1个", style: .default) { (action) in
            print("点击了第1个")
        }
        action1.titleColor = .orange
        
        let action2 = YFAlertAction.action(withTitle: "第2个", style: .default) { (action) in
            print("点击了第2个")
        }
        action2.titleColor = .orange
        
        let action3 = YFAlertAction.action(withTitle: "第3个", style: .default) { (action) in
            print("点击了第3个")
        }
        let action4 = YFAlertAction.action(withTitle: "第4个", style: .default) { (action) in
            print("点击了第4个")
        }
        let action5 = YFAlertAction.action(withTitle: "第5个", style: .destructive) { (action) in
            print("点击了第5个")
        }
        let action6 = YFAlertAction.action(withTitle: "第6个", style: .destructive) { (action) in
            print("点击了第6个")
        }
        let action7 = YFAlertAction.action(withTitle: "取消", style: .cancel) { (action) in
            print("取消")
        }
        if customBlur {
            alertController.customOverlayView = CustomOverlayView()
        }
        action7.titleColor = SYSTEM_COLOR
        alertController.addAction(action: action1)
        alertController.addAction(action: action2)
        alertController.addAction(action: action3)
        alertController.addAction(action: action4)
        alertController.addAction(action: action5)
        alertController.addAction(action: action6)
        alertController.addAction(action: action7)
        //模拟多分区样式
        if #available(iOS 11.0, *) {
            alertController.setCustomSpacing(spacing: 6.0, aferAction: action2)
            alertController.setCustomSpacing(spacing: 6.0, aferAction: action4)
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}
