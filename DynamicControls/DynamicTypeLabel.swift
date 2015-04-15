//
//  DynamicTypeLabel.swift
//  Dynamic Controls
//
//  Created by Joseph Duffy on 16/09/2014.
//  Copyright (c) 2014 Yetii Ltd. All rights reserved.
//

import UIKit

public class DynamicTypeLabel: UILabel {

    public var fontStyle: String?
    private var setupComplete = false

    convenience public init() {
        self.init(fontStyle: UIFontTextStyleBody)
    }

    public init(fontStyle: String) {
        super.init(frame: CGRect.zeroRect)
        self.font = UIFont.preferredFontForTextStyle(fontStyle)
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.setup()
    }

    public func setup() {
        assert(!self.setupComplete, "Setup cannot be called twice")
        
        self.fontStyle = self.currentFontStyle()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "contentSizeCategoryChanged:", name: UIContentSizeCategoryDidChangeNotification, object: nil)
        
        self.setupComplete = true
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        self.preferredMaxLayoutWidth = CGRectGetWidth(self.bounds)
    }

    public func currentFontStyle() -> String {
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
