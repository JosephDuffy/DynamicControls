//
//  DynamicTypeTextField.swift
//  Dynamic Controls
//
//  Created by Joseph Duffy on 10/12/2014.
//  Copyright (c) 2014 Yetii Ltd. All rights reserved.
//

import UIKit

public class DynamicTypeTextField: UITextField {

    convenience public override init() {
        self.init(frame: CGRect.zeroRect)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)

        self.updateFontSize()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "contentSizeCategoryChanged:", name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.updateFontSize()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "contentSizeCategoryChanged:", name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
    
    private func updateFontSize() {
        self.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    }
    
    func contentSizeCategoryChanged(notification: NSNotification) {
        self.updateFontSize()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
