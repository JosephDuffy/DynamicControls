//
//  OneHundredRowsTableViewController.swift
//  Dynamic Controls
//
//  Created by Joseph Duffy on 03/12/2014.
//  Copyright (c) 2014 Yetii Ltd. All rights reserved.
//

import UIKit

class OneHundredRowsTableViewController: DynamicTableViewController {

    private lazy var cellContents: [NSIndexPath : String] = {
        var cellContents = [NSIndexPath : String]()
        
        for section in 0..<self.numberOfSectionsInTableView(self.tableView) {
            for row in 0..<self.tableView(self.tableView, numberOfRowsInSection: section) {
                let indexPath = NSIndexPath(forRow: row, inSection: section)
                let length = (row + 1) * 20
                let randomString = self.randomStringWithLength(length)
                
                cellContents.updateValue(randomString, forKey: indexPath)
            }
        }
        
        return cellContents
    }()
    private lazy var reversedCellContents: [NSIndexPath : String] = {
        var reversedCellContents = [NSIndexPath : String]()
        
        for section in 0..<self.numberOfSectionsInTableView(self.tableView) {
            for row in 0..<self.tableView(self.tableView, numberOfRowsInSection: section) {
                let indexPath = NSIndexPath(forRow: row, inSection: section)
                let randomString = self.cellContents[indexPath]!
                
                var reversedRandomString = ""
                for char in randomString {
                    reversedRandomString = String(char) + reversedRandomString
                }
                
                reversedCellContents.updateValue(reversedRandomString, forKey: indexPath)
            }
        }
        
        return reversedCellContents
    }()
    
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
        return 10
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    override func cellReuseIdentifierForIndexPath(indexPath: NSIndexPath) -> String? {
        if indexPath.row < 5 {
            return "MultiLineLabelCell"
        } else {
            return "MultipleMultiLineLabelCell"
        }
    }

    override func cellContentForIndexPath(indexPath: NSIndexPath) -> [String : AnyObject]? {
        var content = [String : AnyObject]()
        
        if let contents = self.cellContents[indexPath] {
            content.updateValue(contents, forKey: UITableViewCellContentKey.textLabelText.rawValue)
        }
        if let reversedContents = self.reversedCellContents[indexPath] {
            content.updateValue(reversedContents, forKey: "reversedText")
        }
        
        return content
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section + 1)"
    }

}
