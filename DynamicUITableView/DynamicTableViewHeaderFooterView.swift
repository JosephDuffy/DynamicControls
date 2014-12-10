//
//  DynamicTableViewHeaderFooterView.swift
//  Dynamic Controls
//
//  Created by Joseph Duffy on 10/12/2014.
//  Copyright (c) 2014 Yetii Ltd. All rights reserved.
//

import UIKit

class DynamicTableViewHeaderFooterView: UITableViewHeaderFooterView {

    required override init() {
        super.init()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup() {}
    
    func calculateHeightInTableView(tableView: UITableView) -> CGFloat {
        self.setNeedsUpdateConstraints()
        self.updateConstraintsIfNeeded()
        
        self.bounds = CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), CGRectGetHeight(self.bounds))
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        let size = self.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        return size.height
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.contentView.setNeedsLayout()
        self.contentView.layoutIfNeeded()
    }

}
