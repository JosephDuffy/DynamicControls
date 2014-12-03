//
//  UITableViewCell+HeightCalculation.swift
//  AutoLayoutUITableView
//
//  Created by Joseph Duffy on 03/12/2014.
//  Copyright (c) 2014 Yetii Ltd. All rights reserved.
//

import UIKit

extension UITableViewCell {

    class func estimatedHeight() -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func heightForContent(content: [String : AnyObject]?) -> CGFloat {
        if content != nil {
            println("Getting height with some content")
            self.configureForContent(content!)
        }
        println("System layout size: \(self.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize))")
//        return self.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        return self.frame.size.height + 16
//        return UITableViewAutomaticDimension
    }

    func configureForContent(content: [String : AnyObject]) {
        if let textLabelText = content["textLabelText"] as? String {
            self.textLabel.text = textLabelText
        }
    }

}
