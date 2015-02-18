//
//  DynamicTableViewHeaderFooterView.swift
//  Dynamic Controls
//
//  Created by Joseph Duffy on 10/12/2014.
//  Copyright (c) 2014 Yetii Ltd. All rights reserved.
//

import UIKit

public class DynamicTableViewHeaderFooterView: UITableViewHeaderFooterView {

    required override public init() {
        super.init()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    override public init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup() {}
    
    public func calculateHeightInTableView(tableView: UITableView) -> CGFloat {
        self.setNeedsUpdateConstraints()
        self.updateConstraintsIfNeeded()
        
        self.bounds = CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), CGRectGetHeight(self.bounds))
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        let size = self.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        return size.height
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        self.contentView.setNeedsLayout()
        self.contentView.layoutIfNeeded()
    }

}
