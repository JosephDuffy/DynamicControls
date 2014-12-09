//
//  DynamicUITableViewCell.swift
//  DynamicUITableView
//
//  Created by Joseph Duffy on 03/12/2014.
//  Copyright (c) 2014 Yetii Ltd. All rights reserved.
//

import UIKit

class DynamicUITableViewCell: UITableViewCell {
    
    class func estimatedHeight() -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    lazy var horizontalOffset: CGFloat = {
        return self.separatorInset.left
        }()
    
    let verticleOffset: CGFloat = 11.5
    
    required override init() {
        super.init()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Calling init with no params eventually calls this init, so this is where we
        // will do our setup
        self.setup()
    }
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
        
        // +1 for the cell separator
        return size.height + 1
    }
    
    func configureForContent(content: [String : AnyObject]) {
        if let textLabelText = content[UITableViewCellContentKey.textLabelText.rawValue] as? String {
            self.textLabel?.text = textLabelText
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.contentView.setNeedsLayout()
        self.contentView.layoutIfNeeded()
    }
    
}
