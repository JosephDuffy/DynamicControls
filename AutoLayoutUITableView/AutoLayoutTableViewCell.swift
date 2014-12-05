//
//  AutoLayoutTableViewCell.swift
//  AutoLayoutUITableView
//
//  Created by Joseph Duffy on 03/12/2014.
//  Copyright (c) 2014 Yetii Ltd. All rights reserved.
//

import UIKit

class AutoLayoutTableViewCell: UITableViewCell {

    class func estimatedHeight() -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    required override init() {
        super.init()
        
        self.setup()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setup()
    }
    
    func setup() {}

    func heightForContent(content: [String : AnyObject]?, inTableView tableView: UITableView) -> CGFloat {
        if content != nil {
            self.configureForContent(content!)
        }
        
        self.setNeedsUpdateConstraints()
        self.updateConstraintsIfNeeded()
        
        self.bounds = CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), CGRectGetHeight(self.bounds))
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        let size = self.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        
        println("Bottom inset: \(self.separatorInset.bottom)")
        // +1 for the cell separator
        return size.height + 1
    }
    
    func configureForContent(content: [String : AnyObject]) {
        if let textLabelText = content[UITableViewCellContentKey.textLabelText.rawValue] as? String {
            self.textLabel?.text = textLabelText
        }
    }

}
