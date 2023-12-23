//
//  YFInterfaceActionSequenceView.swift
//  YFAlertController
//
//  Created by sky on 2022/10/3.
//

import UIKit

class YFActionSequenceView: UIView {
    var actions: [YFAlertAction] = []
    private var textFieldView: UIStackView?
    private var cancelAction: YFAlertAction?
    private var actionLineConstraints: [NSLayoutConstraint] = []
    public var stackViewDistribution: UIStackView.Distribution? {
        didSet {
            if let value = stackViewDistribution{
                self.stackView.distribution = value
                self.setNeedsUpdateConstraints()
            }
        }
    }
    
    public var axis: NSLayoutConstraint.Axis = .horizontal {
        didSet {
            self.stackView.axis = axis
            //当一个自定义view的某个属性发生改变，并且可能影响到constraint时，需要调用此方法去标记constraints需要在未来的某个点更新，系统然后调用updateConstraints.
            self.setNeedsUpdateConstraints()
        }
    }
    
    public var buttonClickedInActionViewClosure: ((Int)-> Void)?
    
    @objc func buttonClickedInActionView(actionView: YFAlertActionView) {
        var index: Int = 0
        for i in 0..<self.actions.count {
            if actionView.action == self.actions[i] {
                index = i
                break
            }
        }
        self.buttonClickedInActionViewClosure?(index)
    }
    
    
    //MARK: - lazy var
    lazy var contentView: UIView = {
        let contentV = UIView()
        contentV.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.addSubview(contentV)
        return contentV
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollV = UIScrollView()
        scrollV.showsHorizontalScrollIndicator = false
        scrollV.showsVerticalScrollIndicator = false
        scrollV.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            scrollV.contentInsetAdjustmentBehavior = .never
        }
        
        let flag1 = self.cancelAction != nil && self.actions.count > 1
        let flag2 = self.cancelAction == nil && self.actions.count > 0
        if flag1 || flag2 {
            self.addSubview(scrollV)
        }
        return scrollV
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillProportionally
        stack.spacing = YFAlertConfig.minLineHeight // 该间距腾出来的空间显示分割线
        stack.axis = .vertical
        self.contentView.addSubview(stack)
        return stack
    }()
    
    lazy var cancelView: UIView = {
        let cancelV = UIView()
        cancelV.translatesAutoresizingMaskIntoConstraints = false
        if self.cancelAction != nil {
            self.addSubview(cancelV)
        }
        return cancelV
    }()
    
    lazy var cancelActionLine: YFActionItemSeparatorView = {
        let cancelLine = YFActionItemSeparatorView()
        cancelLine.translatesAutoresizingMaskIntoConstraints = false
        if self.cancelView.superview != nil && self.scrollView.superview != nil {
            self.addSubview(cancelLine)
        }
        return cancelLine
    }()
}

extension YFActionSequenceView {
    func setCustomSpacing(spacing: CGFloat, afterActionIndex index: Int) {
        guard let actionView = stackView.arrangedSubviews[index] as? YFAlertActionView else { return}
        actionView.afterSpacing = spacing
        if #available(iOS 11.0, *) {
            stackView.setCustomSpacing(spacing, after: actionView)
        }
        self.updateLineConstraints()
    }
    internal func customSpacingAfterActionIndex(_ index: Int) -> CGFloat {
        
        guard let actionView = stackView.arrangedSubviews[index] as? YFAlertActionView else { return 0.0 }
        if #available(iOS 11.0, *) {
            return stackView.customSpacing(after: actionView)
        } else {
            return 0.0
        }
    }
    
    internal func addAction(action: YFAlertAction) {
        self.actions.append(action)
       
        let currentActionView = YFAlertActionView()
        currentActionView.action = action
        currentActionView.addTarget(target: self, action: #selector(buttonClickedInActionView(actionView:)))
        stackView.addArrangedSubview(currentActionView)
        
        // arrangedSubviews个数大于1，说明本次添加至少是第2次添加，此时要加一条分割线
        if stackView.arrangedSubviews.count > 1 {
            self.addLineForStackView(stackView: stackView)
        }
        self.setNeedsUpdateConstraints()
    }
    
    internal func addCancelAction(action: YFAlertAction) {
        // 如果已经存在取消样式的按钮，则直接崩溃
        assert(cancelAction == nil, "YFAlertController can only have one action with a style of YFAlertActionStyleCancel")
        self.cancelAction = action
        self.actions.append(action)
        
        let cancelActionView = YFAlertActionView()
        cancelActionView.translatesAutoresizingMaskIntoConstraints = false
        cancelActionView.action = action
        cancelActionView.addTarget(target: self, action: #selector(buttonClickedInActionView(actionView:)))
        cancelView.addSubview(cancelActionView)
        
        let leadingConstraint = NSLayoutConstraint(item: cancelActionView, attribute: .leading, relatedBy: .equal, toItem: cancelView, attribute: .leading, multiplier: 1.0, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: cancelActionView, attribute: .trailing, relatedBy: .equal, toItem: cancelView, attribute: .trailing, multiplier: 1.0, constant: 0)
        let topConstraint = NSLayoutConstraint(item: cancelActionView, attribute: .top, relatedBy: .equal, toItem: cancelView, attribute: .top, multiplier: 1.0, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: cancelActionView, attribute: .bottom, relatedBy: .equal, toItem: cancelView, attribute: .bottom, multiplier: 1.0, constant: 0)
        
        cancelView.addConstraints([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])

        self.setNeedsUpdateConstraints()
    }
    
    // 从一个数组筛选出不在另一个数组中的数组
    func filteredArrayFromArray(array: Array<UIView>,notInArray otherArray: [UIView])-> [UIView] {
        let arr = array.filter ({ otherArray.contains($0) == false })
        // 筛选出所有的分割线
        return arr
    }
    
    // 更新分割线约束(细节)
    private func updateLineConstraints() {
        let arrangedSubviews = stackView.arrangedSubviews
        if arrangedSubviews.count <= 1 {
            return
        }
        // 线是 stackView.addSubview(actionLine) 筛选出所有的分割线
        let lines = self.filteredArrayFromArray(array: stackView.subviews, notInArray: stackView.arrangedSubviews)

        if arrangedSubviews.count < lines.count {
            return
        }
        
        if self.actionLineConstraints.count > 0 {
            NSLayoutConstraint.deactivate(self.actionLineConstraints)
            self.actionLineConstraints.removeAll()
        }
        
        for i in 0..<lines.count {
            let actionLine = lines[i]
            guard let actionView1 = arrangedSubviews[i] as? YFAlertActionView else { return }
            guard let actionView2 = arrangedSubviews[i+1] as? YFAlertActionView else { return }
 
           // guard let axis = axis else { return }
            if axis == .horizontal {
                actionLineConstraints.append(NSLayoutConstraint(item: actionLine, attribute: .top, relatedBy: .equal, toItem: stackView, attribute: .top, multiplier: 1.0, constant: 0))
                actionLineConstraints.append(NSLayoutConstraint(item: actionLine, attribute: .bottom, relatedBy: .equal, toItem: stackView, attribute: .bottom, multiplier: 1.0, constant: 0))
                actionLineConstraints.append(NSLayoutConstraint(item: actionLine, attribute: .leading, relatedBy: .equal, toItem: actionView1, attribute: .trailing, multiplier: 1.0, constant: 0))
                actionLineConstraints.append(NSLayoutConstraint(item: actionLine, attribute: .trailing, relatedBy: .equal, toItem: actionView2, attribute: .leading, multiplier: 1.0, constant: 0))
                let lineWidhtContraint = NSLayoutConstraint(item: actionLine, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: actionView1.afterSpacing)
                lineWidhtContraint.priority = UILayoutPriority.defaultLow
                actionLineConstraints.append(lineWidhtContraint)
            } else {
                actionLineConstraints.append(NSLayoutConstraint(item: actionLine, attribute: .leading, relatedBy: .equal, toItem: stackView, attribute: .leading, multiplier: 1.0, constant: 0))
                actionLineConstraints.append(NSLayoutConstraint(item: actionLine, attribute: .trailing, relatedBy: .equal, toItem: stackView, attribute: .trailing, multiplier: 1.0, constant: 0))
                actionLineConstraints.append(NSLayoutConstraint(item: actionLine, attribute: .top, relatedBy: .equal, toItem: actionView1, attribute: .bottom, multiplier: 1.0, constant: 0))
                actionLineConstraints.append(NSLayoutConstraint(item: actionLine, attribute: .bottom, relatedBy: .equal, toItem: actionView2, attribute: .top, multiplier: 1.0, constant: 0))
                
                let lineHeightConstraint = NSLayoutConstraint(item: actionLine, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: actionView1.afterSpacing)
                lineHeightConstraint.priority = UILayoutPriority.defaultLow
                actionLineConstraints.append(lineHeightConstraint)
            }
        }
        NSLayoutConstraint.activate(actionLineConstraints)
    }
    
    
    override func updateConstraints() {
        super.updateConstraints()
        
        // 停用约束
        NSLayoutConstraint.deactivate(self.constraints)
        
        if scrollView.superview != nil {
            // 对scrollView布局
            var scrollViewConstraints = [NSLayoutConstraint]()
            scrollViewConstraints.append(NSLayoutConstraint(item: scrollView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0))
            scrollViewConstraints.append(NSLayoutConstraint(item: scrollView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0))
            scrollViewConstraints.append(NSLayoutConstraint(item: scrollView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0))
            
            if cancelActionLine.superview != nil {
                scrollViewConstraints.append(NSLayoutConstraint(item: scrollView, attribute: .bottom, relatedBy: .equal, toItem: cancelActionLine, attribute: .top, multiplier: 1.0, constant: 0))
            } else {
                scrollViewConstraints.append(NSLayoutConstraint(item: scrollView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0))
            }
            NSLayoutConstraint.activate(scrollViewConstraints)
            NSLayoutConstraint.deactivate(scrollView.constraints)
            
            // 对contentView布局
            var contentViewConstraints = [NSLayoutConstraint]()
            contentViewConstraints.append(NSLayoutConstraint(item: contentView, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leading, multiplier: 1.0, constant: 0))
            contentViewConstraints.append(NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: scrollView, attribute: .trailing, multiplier: 1.0, constant: 0))
            contentViewConstraints.append(NSLayoutConstraint(item: contentView, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .top, multiplier: 1.0, constant: 0))
            contentViewConstraints.append(NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: scrollView, attribute: .bottom, multiplier: 1.0, constant: 0))

            contentViewConstraints.append(NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .equal, toItem: scrollView, attribute: .width, multiplier: 1.0, constant: 0))
            let contentHeightConstraint = NSLayoutConstraint(item: contentView, attribute: .height, relatedBy: .equal, toItem: scrollView, attribute: .height, multiplier: 1.0, constant: 0)
            contentViewConstraints.append(contentHeightConstraint)
            
            // 计算scrolView的最小和最大高度，下面这个if语句是保证当actions的g总个数大于4时，
            // scrollView的高度至少为4个半YFAlertConfig.actionItemHeight的高度，否则自适应内容
            var scrollMinHeight: CGFloat = 0.0
        
            if axis == .vertical {
                if self.cancelAction != nil {
// 如果有取消按钮且action总个数大于4，则除去取消按钮之外的其余部分的高度至少为3个半YFAlertConfig.actionItemHeight的高度,
// 即加上取消按钮就是总高度至少为4个半YFAlertConfig.actionItemHeight的高度
                    if self.actions.count > 4 {
                        scrollMinHeight = YFAlertConfig.actionItemHeight * 3.5
// 优先级为997，必须小于998.0，因为头部如果内容过多时高度也会有限制，
// 头部的优先级为998.0.这里定的规则是，当头部和action部分同时过多时，
// 头部的优先级更高，但是它不能高到以至于action部分小于最小高度
                        contentHeightConstraint.priority = UILayoutPriority(rawValue: 997.0)
                    } else {// 如果有取消按钮但action的个数大不于4，则该多高就显示多高
                        // 由子控件撑起
                        contentHeightConstraint.priority = UILayoutPriority(rawValue: 1000.0)
                    }
                } else {
                    if self.actions.count > 4 {
                        scrollMinHeight = YFAlertConfig.actionItemHeight * 4.5
                        contentHeightConstraint.priority = UILayoutPriority(rawValue: 997.0)
                    } else {
                        contentHeightConstraint.priority = UILayoutPriority(rawValue: 1000.0)
                    }
                }
            } else {
                scrollMinHeight = YFAlertConfig.actionItemHeight
            }
            
            let scrollMinHeightConstraint = NSLayoutConstraint(item: scrollView, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: scrollMinHeight)
            // 优先级不能大于对话框的最小顶部间距的优先级(999.0)
            scrollMinHeightConstraint.priority = UILayoutPriority(rawValue: 999.0)
            scrollMinHeightConstraint.isActive = true

            NSLayoutConstraint.activate(contentViewConstraints)
            NSLayoutConstraint.deactivate(contentView.constraints)
            
            // 对stackView布局
            var stackViewConstraints = [NSLayoutConstraint]()
            stackViewConstraints.append(NSLayoutConstraint(item: stackView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1.0, constant: 0))
            stackViewConstraints.append(NSLayoutConstraint(item: stackView, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1.0, constant: 0))
            stackViewConstraints.append(NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: 0))
            stackViewConstraints.append(NSLayoutConstraint(item: stackView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1.0, constant: 0))
            NSLayoutConstraint.activate(stackViewConstraints)
            
            // 对stackView里面的分割线布局
            self.updateLineConstraints()
        }
        
        // cancelActionLine有superView则必有scrollView和cancelView
        if let cancelLineContainer = cancelActionLine.superview {
            var cancelActionLineConstraints = [NSLayoutConstraint]()
            cancelActionLineConstraints.append(NSLayoutConstraint(item: cancelActionLine, attribute: .leading, relatedBy: .equal, toItem: cancelLineContainer, attribute: .leading, multiplier: 1.0, constant: 0.0))
            cancelActionLineConstraints.append(NSLayoutConstraint(item: cancelActionLine, attribute: .trailing, relatedBy: .equal, toItem: cancelLineContainer, attribute: .trailing, multiplier: 1.0, constant: 0.0))
            
            cancelActionLineConstraints.append(NSLayoutConstraint(item: cancelActionLine, attribute: .bottom, relatedBy: .equal, toItem: cancelView, attribute: .top, multiplier: 1.0, constant: 0.0))
            cancelActionLineConstraints.append(NSLayoutConstraint(item: cancelActionLine, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 8.0))
            NSLayoutConstraint.activate(cancelActionLineConstraints)
        }
        
        // 对cancelView布局 有取消样式的按钮才对cancelView布局
        if cancelAction != nil {
            var cancelViewConstraints = [NSLayoutConstraint]()
            cancelViewConstraints.append(NSLayoutConstraint(item: cancelView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0))
            cancelViewConstraints.append(NSLayoutConstraint(item: cancelView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0))
            cancelViewConstraints.append(NSLayoutConstraint(item: cancelView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0))
            
            if self.cancelActionLine.superview == nil {
                cancelViewConstraints.append(NSLayoutConstraint(item: cancelView, attribute:.top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0))
            }
            NSLayoutConstraint.activate(cancelViewConstraints)
        }
    }
    
    // 为stackView添加分割线(细节)
    private func addLineForStackView(stackView: UIStackView) {
        let actionLine = YFActionItemSeparatorView()
        actionLine.translatesAutoresizingMaskIntoConstraints = false
        // 这里必须用addSubview:，不能用addArrangedSubview:,因为分割线不参与排列布局
        stackView.addSubview(actionLine)
    }
}

