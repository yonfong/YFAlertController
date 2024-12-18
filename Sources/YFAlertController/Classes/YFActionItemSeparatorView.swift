//
//  YFInterfaceActionItemSeparatorView.swift
//  YFAlertController
//
//  Created by sky on 2022/10/3.
//

import UIKit

class YFActionItemSeparatorView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = YFAlertColorConfig.lightLineColor
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        backgroundColor = YFAlertColorConfig.lightLineColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = min(frame.width, frame.height) > YFAlertConfig.minLineHeight ? YFAlertColorConfig.secondaryLineColor : YFAlertColorConfig.lightLineColor
    }
}
