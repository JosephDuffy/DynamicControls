//
//  SegmentedControlTableHeaderFooterView.swift
//  Dynamic Controls
//
//  Created by Joseph Duffy on 01/12/2014.
//  Copyright (c) 2014 Yetii Ltd. All rights reserved.
//

import UIKit

class SegmentedControlTableHeaderFooterView: DynamicTableViewHeaderFooterView {
    
    private(set) var segmentedControl: DynamicFontSegmentedControl!
    private var didUpdateConstraints = false
    var fullConstraits = false
    
    override func setup() {
        assert(self.segmentedControl? == nil, "Setup can only be called once")
        
        self.segmentedControl = DynamicFontSegmentedControl()
        self.segmentedControl.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.contentView.addSubview(self.segmentedControl)
    }
    
    override func updateConstraints() {
        if !self.didUpdateConstraints {
            let segmentedControlSuperview = self.segmentedControl.superview!
            
            let topConstraint = NSLayoutConstraint(item: self.segmentedControl, attribute: .Top, relatedBy: .Equal, toItem: segmentedControlSuperview, attribute: .Top, multiplier: 1, constant: 8)
            let leadingConstraint = NSLayoutConstraint(item: self.segmentedControl, attribute: .Leading, relatedBy: .Equal, toItem: segmentedControlSuperview, attribute: .Leading, multiplier: 1, constant: 8)
            let bottomConstraint = NSLayoutConstraint(item: self.segmentedControl, attribute: .Bottom, relatedBy: .Equal, toItem: segmentedControlSuperview, attribute: .Bottom, multiplier: 1, constant: -8)
            let trailingConstraint = NSLayoutConstraint(item: self.segmentedControl, attribute: .Trailing, relatedBy: .Equal, toItem: segmentedControlSuperview, attribute: .Trailing, multiplier: 1, constant: -8)
            
            // Thses are set to 999 to not be required, fixing a bug. Credit goes to:
            // https://alpha.app.net/ffried/post/41877755
            topConstraint.priority = 999
            leadingConstraint.priority = 999
            bottomConstraint.priority = 999
            trailingConstraint.priority = 999
            
            topConstraint.autoInstall()
            leadingConstraint.autoInstall()
            bottomConstraint.autoInstall()
            trailingConstraint.autoInstall()
            
            self.didUpdateConstraints = true
        }
        
        super.updateConstraints()
        
//        self.contentView.setTranslatesAutoresizingMaskIntoConstraints(true)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.contentView.setNeedsLayout()
        self.contentView.layoutIfNeeded()
    }
}
