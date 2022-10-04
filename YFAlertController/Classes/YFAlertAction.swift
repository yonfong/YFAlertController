//
//  YFAlertAction.swift
//  YFAlertController
//
//  Created by sky on 2022/10/3.
//

import Foundation

open class YFAlertAction: NSObject {
    
    /// Whether button should dismiss popup when tapped
    open var dismissOnTap = true
    
    public var title: String? {
        didSet{
            self.propertyChangedClosure?(self,true)
        }
    }
    /// action的富文本标题
    public var attributedTitle: NSAttributedString? {
        didSet {
            self.propertyChangedClosure?(self,true)
        }
    }
    /// action的图标，位于title的左边
    public var image: UIImage? {
        didSet {
            self.propertyChangedClosure?(self,true)
        }
    }
    /// title跟image之间的间距
    public var imageTitleSpacing: CGFloat = 0 {
        didSet{
            self.propertyChangedClosure?(self,true)
        }
    }
    /// 样式
    public var style: YFAlertActionStyle = .default
    /// 是否能点击,默认为YES
    public var isEnabled: Bool = true {
        didSet{ // enabled改变不需要更新布局
            self.propertyChangedClosure?(self,false)
        }
    }
    /// action的标题颜色,这个颜色只是普通文本的颜色，富文本颜色需要用NSForegroundColorAttributeName
    public var titleColor: UIColor = .black {
        didSet{// 颜色改变不需要更新布局
            self.propertyChangedClosure?(self,false)
        }
    }
    /// action的标题字体,如果文字太长显示不全，会自动改变字体自适应按钮宽度，最多压缩文字为原来的0.5倍封顶
    public var titleFont: UIFont = UIFont.systemFont(ofSize: YFAlertConfig.actionTitleFontSize) {
           didSet{// 字体改变需要更新布局
               self.propertyChangedClosure?(self,true)
           }
       }
    /// action的标题的内边距，如果在不改变字体的情况下想增大action的高度，可以设置该属性的top和bottom值,默认UIEdgeInsetsMake(0, 15, 0, 15)
    public var titleEdgeInsets: UIEdgeInsets = .init(top: 0, left: 15, bottom: 0, right: 15)
    
    public var handler: ((YFAlertAction) ->Void)?
    //当在addAction之后设置action属性时,会回调这个block,设置相应控件的字体、颜色等
    /// 如果没有这个block，那使用时，只有在addAction之前设置action的属性才有效
    internal var propertyChangedClosure: ((YFAlertAction, Bool) ->Void)?
    
    public class func action(withTitle title: String?,
                        style: YFAlertActionStyle,
                        handler: @escaping (YFAlertAction)->Void) -> YFAlertAction {
        let action = YFAlertAction.init(title: title, style: style, handler: handler)
        return action
    }
    
    convenience init(title: String?, style: YFAlertActionStyle, handler: @escaping ((YFAlertAction) ->Void)) {
        
        self.init()
        self.title = title
        self.style = style
        self.handler = handler

        if style == .destructive {
            self.titleColor = YFAlertColorConfig.alertRedColor
            self.titleFont = UIFont.systemFont(ofSize: YFAlertConfig.actionTitleFontSize)
        } else if style == .cancel {
            self.titleColor = YFAlertColorConfig.dynamicBlackColor
            self.titleFont = UIFont.boldSystemFont(ofSize: YFAlertConfig.actionTitleFontSize)
        } else {
            self.titleFont = UIFont.systemFont(ofSize: YFAlertConfig.actionTitleFontSize)
            self.titleColor = YFAlertColorConfig.dynamicBlackColor
        }
    }
    
    deinit {
        debugPrint("\(self.description) deinit")
    }
}

extension YFAlertAction: NSCopying {
    // 由于要对装载action的数组进行拷贝，所以YFAlertAction也需要支持拷贝
    public func copy(with zone: NSZone? = nil) -> Any {
        let action = YFAlertAction()
        action.title = self.title
        action.attributedTitle = self.attributedTitle
        action.image = self.image
        action.imageTitleSpacing = self.imageTitleSpacing
        action.style = self.style
        action.isEnabled = self.isEnabled
        action.titleColor = self.titleColor
        action.titleFont = self.titleFont
        action.titleEdgeInsets = self.titleEdgeInsets
        action.handler = self.handler
        action.propertyChangedClosure = self.propertyChangedClosure
        
        return action
    }
}
