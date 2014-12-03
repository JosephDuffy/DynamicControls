//
//  MultiLineLabelTableViewCell.swift
//  AutoLayoutUITableView
//
//  Created by Joseph Duffy on 03/12/2014.
//  Copyright (c) 2014 Yetii Ltd. All rights reserved.
//

import UIKit

class MultiLineLabelTableViewCell: UITableViewCell {

    private var multiLineLabel: UILabel!
    override var textLabel: UILabel {
        get {
            return self.multiLineLabel
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }

    private func setup() {
        self.multiLineLabel = UILabel()
        self.multiLineLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.multiLineLabel.numberOfLines = 0
        self.multiLineLabel.lineBreakMode = .ByWordWrapping

        self.contentView.addSubview(self.multiLineLabel)
        let padding = self.separatorInset.left
        self.addConstraints([
            NSLayoutConstraint(item: self.multiLineLabel, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: padding),
            NSLayoutConstraint(item: self.multiLineLabel, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: self.multiLineLabel, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: -padding),
            NSLayoutConstraint(item: self.multiLineLabel, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: -8),
            ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.multiLineLabel.preferredMaxLayoutWidth = self.frame.size.width
    }

    override func configureForContent(content: [String : AnyObject]) {
        super.configureForContent(content)
        println("Self frame width: \(self.frame.width)")
        println("Label frame before: \(self.multiLineLabel.frame)")
//        var labelFrame = self.multiLineLabel.frame
//        let size = self.multiLineLabel.sizeThatFits(CGSizeMake(labelFrame.size.width, CGFloat.max))
//        labelFrame.size.height = size.height
//        self.multiLineLabel.frame = labelFrame
//        let size = self.multiLineLabel.sizeThatFits(CGSizeMake(self.frame.size.width, CGFloat.max))
//        self.multiLineLabel.frame = CGRectMake(self.multiLineLabel.frame.origin.x, self.multiLineLabel.frame.origin.x, size.width, size.height)
        var labelFrame = self.multiLineLabel.frame
        labelFrame.size.width = self.frame.width - (self.separatorInset.left * 2)
        self.multiLineLabel.frame = labelFrame
        self.multiLineLabel.sizeToFit()
        println("Label frame after: \(self.multiLineLabel.frame)")
    }

    override func heightForContent(content: [String : AnyObject]?) -> CGFloat {
        if content != nil {
            self.configureForContent(content!)
        }
        return self.multiLineLabel.frame.size.height + 16
    }

}
