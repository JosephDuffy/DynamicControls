//
//  MultipleMultiLineLabelTableViewCell.swift
//  DynamicUITableView
//
//  Created by Joseph Duffy on 04/12/2014.
//  Copyright (c) 2014 Yetii Ltd. All rights reserved.
//

import UIKit

class MultipleMultiLineLabelTableViewCell: MultiLineLabelTableViewCell {
    private var multiLineLabel2: UILabel!
    override var detailTextLabel: UILabel {
        get {
            return self.multiLineLabel2
        }
    }
    
    override func setup() {
        super.setup()
        
        self.multiLineLabel2 = UILabel()
        self.multiLineLabel2.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.multiLineLabel2.numberOfLines = 0
        self.multiLineLabel2.lineBreakMode = .ByWordWrapping
        self.multiLineLabel2.textAlignment = .Left
        
        self.contentView.addSubview(self.multiLineLabel2)
        
    }
    
    override func updateConstraints() {
        if !self.didUpdateConstraints {
            let padding = self.separatorInset.left
            let toItem = self.multiLineLabel.superview
            self.contentView.addConstraints([
                NSLayoutConstraint(item: self.multiLineLabel, attribute: .Leading, relatedBy: .Equal, toItem: toItem, attribute: .Leading, multiplier: 1, constant: padding),
                NSLayoutConstraint(item: self.multiLineLabel, attribute: .Top, relatedBy: .Equal, toItem: toItem, attribute: .Top, multiplier: 1, constant: 8),
                NSLayoutConstraint(item: self.multiLineLabel, attribute: .Trailing, relatedBy: .Equal, toItem: toItem, attribute: .Trailing, multiplier: 1, constant: -padding),
                
                NSLayoutConstraint(item: self.multiLineLabel2, attribute: .Top, relatedBy: .Equal, toItem: self.multiLineLabel, attribute: .Bottom, multiplier: 1, constant: 8),
                
                NSLayoutConstraint(item: self.multiLineLabel2, attribute: .Leading, relatedBy: .Equal, toItem: toItem, attribute: .Leading, multiplier: 1, constant: padding),
                NSLayoutConstraint(item: self.multiLineLabel2, attribute: .Trailing, relatedBy: .Equal, toItem: toItem, attribute: .Trailing, multiplier: 1, constant: -padding),
                NSLayoutConstraint(item: self.multiLineLabel2, attribute: .Bottom, relatedBy: .Equal, toItem: toItem, attribute: .Bottom, multiplier: 1, constant: -8),
                ])
            
            self.didUpdateConstraints = true
        }
        
        super.updateConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.multiLineLabel2.preferredMaxLayoutWidth = CGRectGetWidth(self.multiLineLabel2.frame)
    }
    
    override func configureForContent(content: [String : AnyObject]) {
        super.configureForContent(content)
        if let reversedTextLabelText = content["reversedText"] as? String {
            self.multiLineLabel2.text = reversedTextLabelText
        }
    }

}
