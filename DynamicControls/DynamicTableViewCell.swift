//
//  DynamicTableViewCell.swift
//  Dynamic Controls
//
//  Created by Joseph Duffy on 03/12/2014.
//  Copyright (c) 2014 Yetii Ltd. All rights reserved.
//

import UIKit

public class DynamicTableViewCell: UITableViewCell {
    
    class func estimatedHeight() -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    public var style: UITableViewCellStyle?
    private(set) var setupComplete = false
    private lazy var isLessThaniOS8: Bool = {
        return (UIDevice.currentDevice().systemVersion as NSString).floatValue < 8
        }()
    
    lazy public var horizontalOffset: CGFloat = {
        return self.separatorInset.left
        }()
    
    public let verticleOffset: CGFloat = 11.5
    public var forceUpdateDefaultLabels = false
    
    required override public init() {
        super.init()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.style = style
        
        // Calling init with no params eventually calls this init, so this is where we
        // will do our setup
        self.setup()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
    }
    
    public func setup() {
        assert(!self.setupComplete, "Attempt to call setup on DynamicTableViewCell more than once")
        self.updateFonts()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "contentSizeCategoryChanged:", name: UIContentSizeCategoryDidChangeNotification, object: nil)
        
        self.setupComplete = true
    }
    
    func contentSizeCategoryChanged(notification: NSNotification) {
        self.updateFonts()
    }
    
    func updateFonts() {
        if let style = self.style {
            // On iOS 8+ this is handled for us. Yey!
            if self.isLessThaniOS8 || self.forceUpdateDefaultLabels {
                switch style {
                case .Default:
                    self.textLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
                case .Subtitle:
                    self.textLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
                    self.detailTextLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
                case .Value1:
                    self.textLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
                    self.detailTextLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
                case .Value2:
                    println("Warning: UITableViewCellStyleValue2 does not currently support automatic dynamic font sizing on iOS 7")
                }
            }
        }
    }
    
    public func heightForContent(content: [String : AnyObject]?, inTableView tableView: UITableView) -> CGFloat {
        if content != nil {
            self.configureForContent(content!)
        }
        
        self.setNeedsUpdateConstraints()
        self.updateConstraintsIfNeeded()
        
        self.bounds = CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), CGRectGetHeight(self.bounds))
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        let size = self.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        let boundsHeight = CGRectGetHeight(self.bounds)
        
        if size.height > 0 && size.height >= boundsHeight {
            // +1 for the cell separator
            return size.height + 1
        } else {
            // In some situations (such as the content view not having any/enough constraints to get a height), the
            // size from the systemLayoutSizeFittingSize: will be 0. However, because this can _sometimes_ be intended
            // (e.g., when adding to a default style; see: DynamicSubtitleTableViewCell), we just return
            // the height of the cell as-is. This may make some cells look wrong, but overall will also prevent 0 being returned,
            // hopefully stopping some things from breaking.
            return boundsHeight + 1
        }
    }
    
    public func configureForContent(content: [String : AnyObject]) {
        if let textLabelText = content[DynamicTableViewCellContentKey.textLabelText.rawValue] as? String {
            self.textLabel?.text = textLabelText
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        self.contentView.setNeedsLayout()
        self.contentView.layoutIfNeeded()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}
