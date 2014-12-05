//
//  OneHundredRowsTableViewController.swift
//  AutoLayoutUITableView
//
//  Created by Joseph Duffy on 03/12/2014.
//  Copyright (c) 2014 Yetii Ltd. All rights reserved.
//

import UIKit

class OneHundredRowsTableViewController: AutoLayoutTableViewController {

    private var cellContents: [NSIndexPath : String]!
    private var reversedCellContents: [NSIndexPath : String]!
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
        let styleString: String = (style == .Plain) ? " (plain)" : " (grouped)"
        self.title = "100 Rows \(styleString)"
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.registerClass(MultiLineLabelTableViewCell.self, forCellReuseIdentifier: "MultiLineLabelCell")
        self.registerClass(MultipleMultiLineLabelTableViewCell.self, forCellReuseIdentifier: "MultipleMultiLineLabelCell")
        
        self.tableView.registerClass(SegmentedControlHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: "SegmentedControlHeader")

        self.generateData()
    }
    
    private func generateData() {
        self.cellContents = [NSIndexPath : String]()
        self.reversedCellContents = [NSIndexPath : String]()
        
        for section in 0..<self.numberOfSectionsInTableView(self.tableView) {
            for row in 0..<self.tableView(self.tableView, numberOfRowsInSection: section) {
                let indexPath = NSIndexPath(forRow: row, inSection: section)
                let length = ((section + 1) * (row + 1)) * 10
                let randomString = self.randomStringWithLength(length)
                self.cellContents.updateValue(randomString, forKey: indexPath)
                
                var reversedRandomString = ""
                for char in randomString {
                    reversedRandomString = String(char) + reversedRandomString
                }
                self.reversedCellContents.updateValue(reversedRandomString, forKey: indexPath)
            }
        }
    }
    
    private func randomStringWithLength(length: Int) -> String {
        let charset = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        var randomString = String()
        let max = charset.count - 1
        
        for _ in 0..<length {
            let randomIndex = Int(arc4random_uniform(UInt32((max - 0) + 1))) + 0
            let randomChar = charset[randomIndex]
            randomString.append(randomChar)
        }
        
        return randomString
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    override func cellReuseIdentifierForIndexPath(indexPath: NSIndexPath) -> String? {
        if indexPath.row < 10 {
            return "MultiLineLabelCell"
        } else {
            return "MultipleMultiLineLabelCell"
        }
    }

    override func cellContentForIndexPath(indexPath: NSIndexPath) -> [String : AnyObject]? {
        var content = [String : AnyObject]()
        
        content.updateValue(self.cellContents[indexPath]!, forKey: UITableViewCellContentKey.textLabelText.rawValue)
        content.updateValue(self.reversedCellContents[indexPath]!, forKey: "reversedText")

        return content
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Second Section"
        }
        return nil
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = self.tableView.dequeueReusableHeaderFooterViewWithIdentifier("SegmentedControlHeader") as SegmentedControlHeaderView
            if headerView.segmentedControl.numberOfSegments == 0 {
                headerView.segmentedControl.insertSegmentWithTitle("First (header)", atIndex: 0, animated: false)
                headerView.segmentedControl.insertSegmentWithTitle("Second (header)", atIndex: 1, animated: false)
            }
            return headerView
        }
        return nil
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            let segmentedControlHeight: CGFloat = 29
            let verticlePadding: CGFloat = 8
            return segmentedControlHeight + (verticlePadding * 2)
        }
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            let footerView = self.tableView.dequeueReusableHeaderFooterViewWithIdentifier("SegmentedControlHeader") as SegmentedControlHeaderView
            if footerView.segmentedControl.numberOfSegments == 0 {
                footerView.segmentedControl.insertSegmentWithTitle("First (footer)", atIndex: 0, animated: false)
                footerView.segmentedControl.insertSegmentWithTitle("Second (footer)", atIndex: 1, animated: false)
            }
            return footerView
        }
        return nil
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 44
        }
        return UITableViewAutomaticDimension
    }

}
