//
//  DynamicFontLabel.swift
//  Dynamic Controls
//
//  Created by Joseph Duffy on 16/09/2014.
//  Copyright (c) 2014 Yetii Ltd. All rights reserved.
//

import UIKit

class DynamicFontLabel: UILabel {

    var fontStyle: String?
    var setupComplete = false

    convenience override init() {
        // Calling this also calls super.init()
        self.init(fontStyle: UIFontTextStyleBody)
    }

    init(fontStyle: String) {
        super.init()
        self.font = UIFont.preferredFontForTextStyle(fontStyle)
        self.setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }

    func setup() {
        assert(!self.setupComplete, "Setup cannot be called twice")
        
        self.fontStyle = self.currentFontStyle()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "contentSizeCategoryChanged:", name: UIContentSizeCategoryDidChangeNotification, object: nil)
        
        self.setupComplete = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.preferredMaxLayoutWidth = CGRectGetWidth(self.bounds)
    }

    func currentFontStyle() -> String {
        if self.font.isEqual(UIFont.preferredFontForTextStyle(UIFontTextStyleBody)) {
            return UIFontTextStyleBody
        } else if self.font.isEqual(UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)) {
            return UIFontTextStyleHeadline
        } else if self.font.isEqual(UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)) {
            return UIFontTextStyleCaption1
        } else if self.font.isEqual(UIFont.preferredFontForTextStyle(UIFontTextStyleCaption2)) {
            return UIFontTextStyleCaption2
        } else if self.font.isEqual(UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)) {
            return UIFontTextStyleFootnote
        } else if self.font.isEqual(UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)) {
            return UIFontTextStyleSubheadline
        }
        return UIFontTextStyleBody
    }

    func contentSizeCategoryChanged(notification: NSNotification) {
        if let fontStyle = self.fontStyle {
            self.font = UIFont.preferredFontForTextStyle(fontStyle)
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

}
