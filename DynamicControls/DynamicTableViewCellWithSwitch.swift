//
//  DynamicTableViewCellWithSwitch.swift
//  Dynamic Controls
//
//  Created by Joseph Duffy on 08/10/2014.
//  Copyright (c) 2014 Yetii Ltd. All rights reserved.
//

import UIKit

public class DynamicTableViewCellWithSwitch: DynamicTableViewCell {
    private var label: DynamicTypeLabel!
    override public var textLabel: UILabel? {
        get {
            return self.label
        }
    }
    private(set) public var rowSwitch: UISwitch!
    private var didUpdateConstraints = false
    
    override public func setup() {
        self.style = .Default
        self.forceUpdateDefaultLabels = true
        
        self.selectionStyle = .None
        
        self.label = DynamicTypeLabel()
        self.label.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.contentView.addSubview(self.label)
        
        self.rowSwitch = UISwitch()
        self.rowSwitch.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.contentView.addSubview(self.rowSwitch)
        
        super.setup()
    }
    
    private func addConstraints() {
        self.contentView.addConstraints([
            NSLayoutConstraint(item: self.label, attribute: .Top, relatedBy: .GreaterThanOrEqual, toItem: self.contentView, attribute: .Top, multiplier: 1, constant: self.verticleOffset),
            NSLayoutConstraint(item: self.label, attribute: .Leading, relatedBy: .Equal, toItem: self.contentView, attribute: .Leading, multiplier: 1, constant: self.horizontalOffset),
            NSLayoutConstraint(item: self.label, attribute: .Bottom, relatedBy: .Equal, toItem: self.contentView, attribute: .Bottom, multiplier: 1, constant: -self.verticleOffset),
            // Switch constraints
            NSLayoutConstraint(item: self.rowSwitch, attribute: .CenterY, relatedBy: .Equal, toItem: self.label, attribute: .CenterY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.rowSwitch, attribute: .Leading, relatedBy: .Equal, toItem: self.label, attribute: .Trailing, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: self.rowSwitch, attribute: .Trailing, relatedBy: .Equal, toItem: self.contentView, attribute: .Trailing, multiplier: 1, constant: -self.horizontalOffset)
            ])
        
        self.didUpdateConstraints = true
    }
    
    override public func updateConstraints() {
        if !self.didUpdateConstraints {
            self.addConstraints()
        }
        
        super.updateConstraints()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        self.label.preferredMaxLayoutWidth = CGRectGetWidth(self.label.frame)
        
        if !self.didUpdateConstraints {
            self.addConstraints()
        }
    }
    
    override public func configureForContent(content: [String : AnyObject]) {
        super.configureForContent(content)
        if let switchOn = content["switchOn"] as? Bool {
            self.rowSwitch.on = switchOn
        }
    }
    
}
