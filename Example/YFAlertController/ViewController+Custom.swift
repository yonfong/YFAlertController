//
//  ViewController+Custom.swift
//  YFAlertController
//
//  Created by yonfong on 10/03/2022.
//  Copyright © 2020 yonfong. All rights reserved.
//

import UIKit
import YFAlertController

extension ViewController {
    
    // 示例18:自定义头部(xib)
    func customTest1() {
        let sendAlertView = SendAlertView.loadFromNib()
        let alertController = YFAlertController.alertController(customHeaderView: sendAlertView, preferredStyle: .alert, animationType: .default)
        alertController.needDialogBlur = false
        let action1 = YFAlertAction.action(withTitle: "发送", style: .default) { (action) in
            print("点击了发送")
        }
        let action2 = YFAlertAction.action(withTitle: "取消", style: .destructive) { (action) in
            print("点击了取消")
        }
        if customBlur {
            alertController.customOverlayView = CustomOverlayView()
        }
        alertController.addAction(action: action2)
        alertController.addAction(action: action1)
        self.present(alertController, animated: true, completion: nil)
    }
    // 示例19:自定义整个对话框(alert样式)
    func customTest2() {
        let myView = MyView.loadFromNib()
        myView.cancelButton.addTarget(self, action: #selector(cancelButtonInCustomHeaderViewClicked), for: .touchUpInside)
        let alertController = YFAlertController.alertController(customAlertView: myView, preferredStyle: .alert, animationType: .default)
        alertController.offsetForAlert = CGPoint(x: 0, y: -100)
        if customBlur {
            alertController.customOverlayView = CustomOverlayView()
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func cancelButtonInCustomHeaderViewClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // 示例20:自定义整个对话框(actionSheet样式从底部弹出)
    func customTest3() {
        let shoppingCartView = ShoppingCartView()
        let alertController = YFAlertController.alertController(customAlertView: shoppingCartView, preferredStyle: .actionSheet, animationType: .fromBottom)
        alertController.needDialogBlur = false
        alertController.updateCustomViewSize(size: CGSize(width: ScreenWidth, height: ScreenHeight*2/3))
        if customBlur {
            alertController.customOverlayView = CustomOverlayView()
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    // 示例21:自定义整个对话框(actionSheet样式从右边弹出)
    func customTest4() {
        let shoppingCartView = ShoppingCartView(frame: CGRect(x: 0, y: 0, width: ScreenWidth-70, height: ScreenHeight))
        shoppingCartView.backgroundColor = .white
        let alertController = YFAlertController.alertController(customAlertView: shoppingCartView, preferredStyle: .actionSheet, animationType: .fromRight)
        if customBlur {
            alertController.customOverlayView = CustomOverlayView()
        }
        self.present(alertController, animated: true, completion: nil)
    }
    // 示例22:自定义整个对话框(actionSheet样式从左边弹出)
    func customTest5() {
        let shoppingCartView = ShoppingCartView(frame: CGRect(x: 0, y: 0, width: ScreenWidth-70, height: ScreenHeight))
        shoppingCartView.backgroundColor = .white
        let alertController = YFAlertController.alertController(customAlertView: shoppingCartView, preferredStyle: .actionSheet, animationType: .fromLeft)
        if customBlur {
            alertController.customOverlayView = CustomOverlayView()
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    // 示例23:自定义整个对话框(actionSheet样式从顶部弹出)
    func customTest6() {
        let shoppingCartView = CommodityListView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 200))
        shoppingCartView.backgroundColor = .white
        let alertController = YFAlertController.alertController(customAlertView: shoppingCartView, preferredStyle: .actionSheet, animationType: .fromTop)
        if customBlur {
            alertController.customOverlayView = CustomOverlayView()
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    // 示例24:自定义整个对话框(pickerView)
    func customTest7() {
        let pickerView = PickerView.loadFromNib()
        pickerView.backgroundColor = .white
        pickerView.cancelClickedClosure = { [weak self] in
            self?.presentedViewController?.dismiss(animated: true, completion: nil)
        }
        pickerView.doneClickedClosure = { [weak self] in
            self?.presentedViewController?.dismiss(animated: true, completion: nil)
        }
        let alertController = YFAlertController.alertController(customAlertView: pickerView, preferredStyle: .actionSheet, animationType: .fromBottom)
        if customBlur {
            alertController.customOverlayView = CustomOverlayView()
        }
        self.present(alertController, animated: true, completion: nil)
    }
    // 示例25:自定义action部分
    func customTest8() {
        // scoreview的子控件采用的是自动布局，由于高度上能够由子控件撑起来，所以高度可以给0，如果宽度也能撑起，宽度也可以给0
        let scoreView = ScoreView(frame: CGRect(x: 0, y: 0, width: 275, height: 0))
        scoreView.backgroundColor = .white
        scoreView.finishClickedClosure = { [weak self] in
            self?.presentedViewController?.dismiss(animated: true, completion: nil)
        }
        
        let alertController = YFAlertController.alertController(customActionSequenceView: scoreView, title: "提示", message: "请给我们的app打分", preferredStyle: .alert, animationType: .default)
        alertController.needDialogBlur = false
        if customBlur {
            alertController.customOverlayView = CustomOverlayView()
        }
        self.present(alertController, animated: true, completion: nil)
    }
    // 示例25:插入一个组件
    func customTest9() {
        let centerView = MyCenterView(frame: CGRect(x: 0, y: 0, width: ScreenWidth-40, height: 200))
        let alertController = YFAlertController.alertController(title: "我是主标题", message: "我是副标题", preferredStyle: .alert, animationType: .default)
        // 插入一个view
        alertController.insertComponentView(centerView)
        
        let action1 = YFAlertAction.action(withTitle: "第1个", style: .default) { (action) in
            print("点击了第1个")
        }
        action1.titleColor = SYSTEM_COLOR
        let action2 = YFAlertAction.action(withTitle: "第2个", style: .destructive) { (action) in
            print("点击了第2个")
        }
        action2.titleColor = .red
        if customBlur {
            alertController.customOverlayView = CustomOverlayView()
        }
        alertController.addAction(action: action1)
        alertController.addAction(action: action2)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
