//
//  UITableViewCellAsButton.swift
//  DynamicUITableView
//
//  Created by Joseph Duffy on 01/12/2014.
//  Copyright (c) 2014 Yetii Ltd. All rights reserved.
//

import UIKit

public class DynamicTableViewCellAsButton: DynamicTableViewCell {
    private var label: DynamicTypeLabel!
    override public var textLabel: DynamicTypeLabel {
        get {
            return self.label
        }
    }
    public var enabled: Bool! {
        didSet {
            if self.enabled == true {
                self.label.textColor = self.tintColor
                self.label.alpha = 1
                self.selectionStyle = .Default
            } else {
                self.label.textColor = UIColor.grayColor()
                self.label.alpha = 0.7
                self.selectionStyle = .None
            }
        }
    }
    private var didUpdateConstraints = false

    override public func setup() {
        self.label = DynamicTypeLabel()
        self.label.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.label.textAlignment = .Center
        
        self.accessibilityTraits |= UIAccessibilityTraitButton
        
        // Setting this value also sets the text color of the label
        self.enabled = true
        
        self.contentView.addSubview(self.label)
    }
    
    override public func updateConstraints() {
        if !self.didUpdateConstraints {
            self.contentView.addConstraints([
                NSLayoutConstraint(item: self.label, attribute: .Top, relatedBy: .GreaterThanOrEqual, toItem: self.contentView, attribute: .Top, multiplier: 1, constant: self.verticleOffset),
                NSLayoutConstraint(item: self.label, attribute: .Leading, relatedBy: .Equal, toItem: self.contentView, attribute: .Leading, multiplier: 1, constant: self.horizontalOffset),
                NSLayoutConstraint(item: self.label, attribute: .Bottom, relatedBy: .Equal, toItem: self.contentView, attribute: .Bottom, multiplier: 1, constant: -self.verticleOffset),
                NSLayoutConstraint(item: self.label, attribute: .Trailing, relatedBy: .Equal, toItem: self.contentView, attribute: .Trailing, multiplier: 1, constant: -self.horizontalOffset)
                ])
            
            self.didUpdateConstraints = true
        }
        
        super.updateConstraints()
    }
    
}
