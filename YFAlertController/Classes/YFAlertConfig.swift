//
//  YFConstant.swift
//  YFAlertController
//
//  Created by sky on 2022/10/3.
//

import Foundation

public enum YFAlertControllerStyle {
    case actionSheet
    case alert
}

public enum YFAlertAnimationType: Int {
    case `default`
    case fromBottom
    case fromTop
    case fromRight
    case fromLeft
    
    case shrink
    case expand
    case fade
    case none
}

public enum YFAlertActionStyle {
    case `default`
    case cancel
    case destructive
}

public struct YFAlertConfig {
    static var keyWindow: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
    
    static let isIPhoneXSeries = { () -> Bool in
        let iPhoneXSeries = false
        if UIDevice.current.userInterfaceIdiom != .phone {
            return iPhoneXSeries
        }
        
        if let keyWindow = keyWindow {
            if #available(iOS 11.0, *) {
                return keyWindow.safeAreaInsets.bottom > 0
            } else {
                return false
            }
        }
        
        return iPhoneXSeries
    }()
    
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    
    static let windowSafeAreaInset = { () -> UIEdgeInsets in
        var insets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        if #available(iOS 11.0, *) {
            insets = keyWindow?.safeAreaInsets ?? insets
        }
        return insets
    }
    
    static let safeAreaTop = windowSafeAreaInset().top == 0 ? 20 : windowSafeAreaInset().top
    static let safeAreaBottom = windowSafeAreaInset().bottom
    static let statusBarHeight = windowSafeAreaInset().top
    
    static let minLineHeight = 1 / UIScreen.main.scale
    
    
    static let actionTitleFontSize: CGFloat = 18
    static let actionItemHeight: CGFloat = 55
}

public struct YFAlertColorConfig {
    static var normalColor: UIColor {
        return .dynamicColor(defaultColor: UIColor.white.withAlphaComponent(0.7), darkColor: UIColor(red: 44.0 / 255.0, green: 44.0 / 255.0, blue: 44.0 / 255.0, alpha: 1))
    }
    
    static var selectedColor: UIColor {
        return .dynamicColor(defaultColor: UIColor.gray.withAlphaComponent(0.1), darkColor: UIColor(red: 55.0 / 255.0, green: 55.0 / 255.0, blue: 55.0 / 255.0, alpha: 1))
    }
    
    static var lineColor: UIColor {
        return .dynamicColor(defaultColor: lightLineColor, darkColor: darkLineColor)
    }
    
    static var secondaryLineColor: UIColor {
        return .dynamicColor(defaultColor: UIColor.gray.withAlphaComponent(0.15), darkColor: UIColor(red: 29.0 / 255.0, green: 29.0 / 255.0, blue: 29.0 / 255.0, alpha: 1))
    }
    
    static var dynamicWhiteColor: UIColor {
        return .dynamicColor(defaultColor: UIColor.white, darkColor: UIColor.black)
    }
    
    static var dynamicBlackColor: UIColor {
        return .dynamicColor(defaultColor: UIColor.black, darkColor: UIColor.white)
    }
    
    static var lightLineColor: UIColor {
        return UIColor.gray.withAlphaComponent(0.3)
    }
    
    static var darkLineColor: UIColor {
        return UIColor(red: 60.0 / 255.0, green: 60.0 / 255.0, blue: 60.0 / 255.0, alpha: 1)
    }
    
    static var textViewBackgroundColor: UIColor {
        return .dynamicColor(defaultColor: UIColor(red: 247.0 / 255.0, green: 247.0 / 255.0, blue: 247.0 / 255.0, alpha: 1), darkColor: UIColor(red: 54.0 / 255.0, green: 54.0 / 255.0, blue: 54.0 / 255.0, alpha: 1))
    }
    
    static var alertRedColor: UIColor {
        return .systemRed
    }
    
    static var grayColor: UIColor {
        return .gray
    }
    
    static var textFieldBorderColor: UIColor {
        return .staticColor(defaultColor: lineColor, darkColor: darkLineColor)
    }
}


public extension UIColor {
    static func dynamicColor(defaultColor: UIColor, darkColor: UIColor?) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { traitCollection in
                if traitCollection.userInterfaceStyle == .dark {
                    return darkColor ?? defaultColor
                }
                return defaultColor
            }
        } else {
            return defaultColor
        }
    }
    
    static func staticColor(defaultColor: UIColor, darkColor: UIColor?) -> UIColor {
        if #available(iOS 13.0, *) {
            let mode = UITraitCollection.current.userInterfaceStyle
            if mode == .dark {
                return darkColor ?? defaultColor
            } else {
                return defaultColor
            }
        } else {
            return defaultColor
        }
    }
}



