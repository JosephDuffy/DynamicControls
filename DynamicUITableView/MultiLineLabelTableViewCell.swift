//
//  MultiLineLabelTableViewCell.swift
//  DynamicUITableView
//
//  Created by Joseph Duffy on 03/12/2014.
//  Copyright (c) 2014 Yetii Ltd. All rights reserved.
//

import UIKit

class MultiLineLabelTableViewCell: DynamicUITableViewCell {

    var multiLineLabel: UILabel!
    override var textLabel: UILabel {
        get {
            return self.multiLineLabel
        }
    }
    var didUpdateConstraints = false

    required init() {
        super.init()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    override func setup() {
        self.multiLineLabel = UILabel()
        self.multiLineLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.multiLineLabel.numberOfLines = 0
        self.multiLineLabel.lineBreakMode = .ByWordWrapping
        self.multiLineLabel.textAlignment = .Left

        self.contentView.addSubview(self.multiLineLabel)
        
    }
    
    override func updateConstraints() {
        if !self.didUpdateConstraints {
            let padding = self.separatorInset.left
            let toItem = self.multiLineLabel.superview
            self.contentView.addConstraints([
                NSLayoutConstraint(item: self.multiLineLabel, attribute: .Leading, relatedBy: .Equal, toItem: toItem, attribute: .Leading, multiplier: 1, constant: padding),
                NSLayoutConstraint(item: self.multiLineLabel, attribute: .Top, relatedBy: .Equal, toItem: toItem, attribute: .Top, multiplier: 1, constant: 8),
                NSLayoutConstraint(item: self.multiLineLabel, attribute: .Trailing, relatedBy: .Equal, toItem: toItem, attribute: .Trailing, multiplier: 1, constant: -padding),
                NSLayoutConstraint(item: self.multiLineLabel, attribute: .Bottom, relatedBy: .Equal, toItem: toItem, attribute: .Bottom, multiplier: 1, constant: -8),
                ])
            
            self.didUpdateConstraints = true
        }
        
        super.updateConstraints()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.contentView.setNeedsLayout()
        self.contentView.layoutIfNeeded()
        
        self.multiLineLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.multiLineLabel.frame)
    }

}
