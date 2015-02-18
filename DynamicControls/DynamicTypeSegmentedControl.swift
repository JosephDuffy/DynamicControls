//
//  DynamicTypeSegmentedControl.swift
//  Dynamic Controls
//
//  Created by Joseph Duffy on 10/12/2014.
//  Copyright (c) 2014 Yetii Ltd. All rights reserved.
//

import UIKit

public class DynamicTypeSegmentedControl: UISegmentedControl {

    override public init() {
        super.init()
        self.updateFontSize()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "contentSizeCategoryChanged:", name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override public init(items: [AnyObject]!) {
        super.init(items: items)
    }

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func updateFontSize() {
        let font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
        self.setTitleTextAttributes([NSFontAttributeName: font], forState: .Normal)
    }
    
    func contentSizeCategoryChanged(notification: NSNotification) {
        self.updateFontSize()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

}
