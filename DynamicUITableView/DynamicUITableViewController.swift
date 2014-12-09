//
//  DynamicUITableViewController.swift
//  DynamicUITableView
//
//  Created by Joseph Duffy on 03/12/2014.
//  Copyright (c) 2014 Yetii Ltd. All rights reserved.
//

import UIKit

class DynamicUITableViewController: UITableViewController {
    
    private lazy var isiOS8OrGreater: Bool = {
        return (UIDevice.currentDevice().systemVersion as NSString).floatValue >= 8.0
        }()
    
    private var cachedClassesForCellReuseIdentifiers = [String : DynamicUITableViewCell.Type]()
    private var offscreenCellRowsForReuseIdentifiers = [String : DynamicUITableViewCell]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting the estimated row height prevents the table view from calling tableView:heightForRowAtIndexPath: for every row in the table on first load;
        // it will only be called as cells are about to scroll onscreen. This is a major performance optimization.
        self.tableView.estimatedRowHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if !self.isiOS8OrGreater {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "contentSizeCategoryChanged:", name: UIContentSizeCategoryDidChangeNotification, object: nil)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        if !self.isiOS8OrGreater {
            NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
        }
    }
    
    func contentSizeCategoryChanged(notification: NSNotification) {
        // TODO: This doesn't always seem to force cell height changes?
        self.tableView.reloadData()
    }
    
    // MARK:- Methods to call
    
    // Row Cells
    
    func registerClass(cellClass: DynamicUITableViewCell.Type, forCellReuseIdentifier reuseIdentifier: String) {
        self.cachedClassesForCellReuseIdentifiers[reuseIdentifier] = cellClass
        self.tableView.registerClass(cellClass, forCellReuseIdentifier: reuseIdentifier)
    }
    
    // MARK:- Methods to be overridden
    
    // MARK: Row cells
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let reuseIdentifier = self.cellReuseIdentifierForIndexPath(indexPath) {
            if let cell = self.tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as? DynamicUITableViewCell {
                if let cellContent = self.cellContentForIndexPath(indexPath) {
                    cell.configureForContent(cellContent)
                    
                    // This must be called when using an auto layout cell and the contents of the cell change
                    cell.setNeedsUpdateConstraints()
                    cell.updateConstraintsIfNeeded()
                }
                return cell
            } else {
                fatalError("Could not dequeue a reusable cell for supplied reuse identifier: \(reuseIdentifier)")
            }
        } else {
            fatalError("Could not get a reuse identifier for section \(indexPath.section), row \(indexPath.row)")
        }
    }
    
    /**
    Get the reuse identifier for the specified index path.
    
    Returning nil from this method will cause height calculations to not be performed
    for the given index path. If you do return nil, you **must** override the
    tableView:cellForRowAtIndexPath method in your subclass and return a UITableViewCell instance.
    
    :param: indexPath The index path to return the cell's reuse identifier for
    
    :return: The cell's reuse identifier for the given index path, or nil
    */
    func cellReuseIdentifierForIndexPath(indexPath: NSIndexPath) -> String? {
        return nil
    }
    
    func cellContentForIndexPath(indexPath: NSIndexPath) -> [String : AnyObject]? {
        return nil
    }
    
    /**
    In most cases, you will not need to override this method (especially in iOS 8 or higher).
    By default, this method will handle the calculation for the height of a cell at the given index path.
    If a cell at a specific index path has a known height you may return it here
    
    :param: tableView The table-view object requesting this information.
    :param: indexPath An index path that locates a row in tableView.
    
    :return: A nonnegative floating-point value that specifies the height (in points) that row should be.
    */
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if !self.isiOS8OrGreater {
            // This method is called with an NSMutableIndexPath, which is not compatible with an imutable NSIndexPath,
            // so we create an imutable NSIndexPath to be passed to the following methods
            let imutableIndexPath = NSIndexPath(forRow: indexPath.row, inSection: indexPath.section)
            
            if let reuseIdentifier = self.cellReuseIdentifierForIndexPath(imutableIndexPath) {
                if let cell = self.cellForReuseIdentifier(reuseIdentifier) {
                    return cell.heightForContent(self.cellContentForIndexPath(imutableIndexPath), inTableView: tableView)
                }
            }
        }
        return UITableViewAutomaticDimension
    }
    
    /**
    It can sometimes be useful to override this this method if you have a static estimated height. It is often a
    better idea to override the estimatedHeight class-method in the AutoLayoutTableViewCell class.
    By default, this method will always return UITableViewAutomaticDimension
    
    :param: tableView The table-view object requesting this information.
    :param: indexPath An index path that locates a row in tableView.
    
    :return: A nonnegative floating-point value that specifies the height (in points) that row should be.
    */
    /*
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if !self.isiOS8OrGreater {
            // This method is called with an NSMutableIndexPath, which is not compatible with an imutable NSIndexPath,
            // so we create an imutable NSIndexPath to be passed to the following methods
            let imutableIndexPath = NSIndexPath(forRow: indexPath.row, inSection: indexPath.section)
    
            if let reuseIdentifier = self.cellReuseIdentifierForIndexPath(indexPath) {
                if let cellType = self.cachedClassesForCellReuseIdentifiers[reuseIdentifier] {
                    return cellType.estimatedHeight()
                }
            }
        }
        return UITableViewAutomaticDimension
    }
    */
    
    // MARK:- Private methods
    
    // MARK: Cell rows
    
    private func cellForReuseIdentifier(reuseIdentifier: String) -> DynamicUITableViewCell? {
        if self.offscreenCellRowsForReuseIdentifiers[reuseIdentifier] == nil {
            if let cellClass = self.cachedClassesForCellReuseIdentifiers[reuseIdentifier] {
                let cell = cellClass()
                self.offscreenCellRowsForReuseIdentifiers[reuseIdentifier] = cell
            }
        }
        return self.offscreenCellRowsForReuseIdentifiers[reuseIdentifier]
    }
}
