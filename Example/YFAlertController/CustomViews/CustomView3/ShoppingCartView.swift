//
//  ShoppingCartView.swift
//  YFAlertController
//
//  Created by yonfong on 10/03/2022.
//  Copyright © 2020 yonfong. All rights reserved.
//

import UIKit

class ShoppingCartView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(topLabel)
        self.addSubview(tableView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var topLabelY: CGFloat = 0.0
        if #available(iOS 11, *) {
            topLabelY = self.safeAreaInsets.top
        } else {
            topLabelY = 20
        }
        topLabel.frame = CGRect(x: 0, y: topLabelY, width: self.bounds.size.width, height: 44)
        let tableViewY: CGFloat = topLabel.frame.maxY
        tableView.frame = CGRect(x: 0, y: tableViewY, width: self.bounds.size.width, height: self.bounds.size.height-tableViewY)
    }
    
    lazy var topLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        label.text = "购物车"
        label.textAlignment = .center
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tableV = UITableView(frame: .zero, style: .plain)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.showsVerticalScrollIndicator = false
        tableV.register(UINib(nibName: "ShoppingCartCell", bundle: nil), forCellReuseIdentifier: "ShoppingCartCell")
        return tableV
    }()
}

extension ShoppingCartView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingCartCell")!
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
