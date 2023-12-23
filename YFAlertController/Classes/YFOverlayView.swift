//
//  YFOverlayView.swift
//  YFAlertController
//
//  Created by sky on 2022/10/3.
//

import UIKit

class YFOverlayView: UIView {
    private var effectView: UIVisualEffectView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.isUserInteractionEnabled = true
    }
        
    func configBlurEffectStyle(style: UIBlurEffect.Style?, alpha: CGFloat) {
        effectView?.removeFromSuperview()
        effectView = nil
        
        guard let style = style else {
            let targetAlpha = alpha < 0 ? 0.5 : alpha
            self.backgroundColor = UIColor(white: 0, alpha: targetAlpha)
            self.alpha = 0
            return
        }
        
        let blurEffect = UIBlurEffect(style: style)
        creatVisualEffectView(with: blurEffect, alpha: alpha)
    }
    
    func creatVisualEffectView(with blurEffect: UIBlurEffect, alpha: CGFloat) {
        self.backgroundColor = .clear
        let effectV = UIVisualEffectView(frame: self.bounds)
        effectV.effect = blurEffect
        effectV.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        effectV.isUserInteractionEnabled = false
        effectV.alpha = alpha
        self.addSubview(effectV)
        effectView = effectV
    }
}
