//
//  DynamicFontTextField.swift
//  Dynamic Controls
//
//  Created by Joseph Duffy on 10/12/2014.
//  Copyright (c) 2014 Yetii Ltd. All rights reserved.
//

import UIKit

class DynamicFontTextField: UITextField {

    override init() {
        super.init()
        self.updateFontSize()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "contentSizeCategoryChanged:", name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateFontSize() {
        let font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        self.font = font
    }
    
    func contentSizeCategoryChanged(notification: NSNotification) {
        self.updateFontSize()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
