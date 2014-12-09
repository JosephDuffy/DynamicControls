//
//  SegmentedControlHeaderView.swift
//  Dynamic UITableView
//
//  Created by Joseph Duffy on 05/12/2014.
//  Copyright (c) 2014 Yetii Ltd. All rights reserved.
//

import UIKit

class SegmentedControlHeaderView: UITableViewHeaderFooterView {

    private(set) var segmentedControl: UISegmentedControl!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
    }
    
    func setup() {
        assert(self.segmentedControl? == nil, "Setup can only be called once")
        
        self.segmentedControl = UISegmentedControl()
        self.segmentedControl.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.contentView.addSubview(self.segmentedControl)
        self.addConstraints([
            NSLayoutConstraint(item: self.segmentedControl, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: self.segmentedControl, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: self.segmentedControl, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: -8),
            NSLayoutConstraint(item: self.segmentedControl, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: -8)
            ])
    }

}
