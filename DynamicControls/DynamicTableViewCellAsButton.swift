//
//  DynamicTableViewCellAsButton.swift
//  Dynamic Controls
//
//  Created by Joseph Duffy on 01/12/2014.
//  Copyright (c) 2014 Yetii Ltd. All rights reserved.
//

import UIKit

public class DynamicTableViewCellAsButton: DynamicTableViewCell {

    public var enabled: Bool! {
        didSet {
            if self.enabled == true {
                self.textLabel?.textColor = self.tintColor
                self.textLabel?.alpha = 1
                self.selectionStyle = .Default
            } else {
                self.textLabel?.textColor = UIColor.grayColor()
                self.textLabel?.alpha = 0.7
                self.selectionStyle = .None
            }
        }
    }
    private var didUpdateConstraints = false

    override public func setup() {
        self.textLabel?.textAlignment = .Center
        
        self.accessibilityTraits |= UIAccessibilityTraitButton
        
        // Setting this value also sets the text color of the label
        self.enabled = true
        
    }
    
}
