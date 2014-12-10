//
//  UITableViewCellAsButton.swift
//  DynamicUITableView
//
//  Created by Joseph Duffy on 01/12/2014.
//  Copyright (c) 2014 Yetii Ltd. All rights reserved.
//

import UIKit

class UITableViewCellAsButton: DynamicTableViewCell {
    private var label: DynamicFontLabel!
    override var textLabel: DynamicFontLabel {
        get {
            return self.label
        }
    }
    var enabled: Bool! {
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

    override func setup() {
        self.label = DynamicFontLabel()
        self.label.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.label.textAlignment = .Center
        
        // Setting this value also sets the text color of the label
        self.enabled = true
        
        self.contentView.addSubview(self.label)
    }
    
    override func updateConstraints() {
        if !self.didUpdateConstraints {
            self.label.autoPinEdge(.Top, toEdge: .Top, ofView: self.label.superview!, withOffset: self.verticleOffset, relation: .GreaterThanOrEqual)
            self.label.autoPinEdge(.Leading, toEdge: .Leading, ofView: self.label.superview!, withOffset: self.horizontalOffset, relation: .Equal)
            self.label.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self.label.superview!, withOffset: -self.verticleOffset, relation: .Equal)
            self.label.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: self.label.superview!, withOffset: -self.horizontalOffset, relation: .Equal)
            
            self.didUpdateConstraints = true
        }
        
        super.updateConstraints()
    }
    
}
