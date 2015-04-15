//
//  DynamicTableViewController.swift
//  Dynamic Controls
//
//  Created by Joseph Duffy on 03/12/2014.
//  Copyright (c) 2014 Yetii Ltd. All rights reserved.
//

import UIKit

public class DynamicTableViewController: UITableViewController {
    
    private var cachedClassesForCellReuseIdentifiers = [String : UITableViewCell.Type]()
    private var cachedNibsForCellReuseIdentifiers = [String : UINib]()
    private var offscreenCellRowsForReuseIdentifiers = [String : UITableViewCell]()
    
    private var cachedClassesForSectionHeaderFooterReuseIdentifiers = [String : DynamicTableViewHeaderFooterView.Type]()
    private var offscreenSectionHeadersForReuseIdentifiers = [String : DynamicTableViewHeaderFooterView]()
    private var offscreenSectionFootersForReuseIdentifiers = [String : DynamicTableViewHeaderFooterView]()

    private var offScreenWindow: UIWindow = {
        return UIWindow(frame: UIScreen.mainScreen().applicationFrame)
    }()
    
    lazy var isiOS8OrGreater: Bool = {
        return (UIDevice.currentDevice().systemVersion as NSString).floatValue >= 8.0
        }()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting the estimated row height prevents the table view from calling tableView:heightForRowAtIndexPath: for
        // every row in the table on first load; it will only be called as cells are about
        // to scroll onscreen. This is a major performance optimization.
        self.tableView.estimatedRowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedSectionFooterHeight = UITableViewAutomaticDimension
        self.tableView.estimatedSectionHeaderHeight = UITableViewAutomaticDimension
    }
    
    override public func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if !self.isiOS8OrGreater {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "contentSizeCategoryChanged:", name: UIContentSizeCategoryDidChangeNotification, object: nil)
        }
    }
    
    override public func viewWillDisappear(animated: Bool) {
        if !self.isiOS8OrGreater {
            NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
        }
    }
    
    func contentSizeCategoryChanged(notification: NSNotification) {
        // TODO: This doesn't always seem to force cell height changes?
        self.tableView.reloadData()
    }
    
    // MARK:- Methods to call
    
    // MARK: Row Cells
    
    public func registerClass(cellClass: UITableViewCell.Type, forCellReuseIdentifier reuseIdentifier: String) {
        self.cachedClassesForCellReuseIdentifiers[reuseIdentifier] = cellClass
        self.tableView.registerClass(cellClass, forCellReuseIdentifier: reuseIdentifier)
    }

    public func registerNib(nib: UINib, forCellReuseIdentifier reuseIdentifier: String) {
        self.cachedNibsForCellReuseIdentifiers[reuseIdentifier] = nib
        self.tableView.registerNib(nib, forCellReuseIdentifier: reuseIdentifier)
    }
    
    // MARK: Section Headers and Footers
    
    public func registerClass(aClass: DynamicTableViewHeaderFooterView.Type, forHeaderFooterViewReuseIdentifier reuseIdentifier: String) {
        self.cachedClassesForSectionHeaderFooterReuseIdentifiers[reuseIdentifier] = aClass
        self.tableView.registerClass(aClass, forHeaderFooterViewReuseIdentifier: reuseIdentifier)
    }
    
    // MARK:- Methods to be overridden
    
    // MARK: Row cells
    
    public func configureCell(cell: UITableViewCell, forIndexPath indexPath: NSIndexPath) {
        // By default, this does nothing, but should be overridden by subclasses
    }
    
    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let reuseIdentifier = self.cellReuseIdentifierForIndexPath(indexPath) {
            if let cell = self.tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as? UITableViewCell {
                self.configureCell(cell, forIndexPath: indexPath)

                cell.setNeedsUpdateConstraints()
                cell.updateConstraintsIfNeeded()
                
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
    for the given index path and the cell will not be automatically created in the tableView:cellForRowAtIndexPath: metho.
    Due to this, if you do return nil, you **must** override the tableView:cellForRowAtIndexPath: method
    in your subclass and return a UITableViewCell instance, or your app will crash.
    
    :param: indexPath The index path to return the cell's reuse identifier for
    
    :return: The cell's reuse identifier for the given index path, or nil
    */
    public func cellReuseIdentifierForIndexPath(indexPath: NSIndexPath) -> String? {
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
    override public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // This method is called with an NSMutableIndexPath, which is not compatible with an imutable NSIndexPath,
        // so we create an imutable NSIndexPath to be passed to the following methods
        let imutableIndexPath = NSIndexPath(forRow: indexPath.row, inSection: indexPath.section)
        
        if let reuseIdentifier = self.cellReuseIdentifierForIndexPath(imutableIndexPath) {
            if let cell = self.cellForReuseIdentifier(reuseIdentifier) {
                self.configureCell(cell, forIndexPath: indexPath)

                if let dynamicCell = cell as? DynamicTableViewCell {
                    return dynamicCell.heightInTableView(tableView)
                } else {
                    // Fallback for non-DynamicTableViewCell cells
                    let size = cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
                    let cellBoundsHeight = CGRectGetHeight(cell.bounds)
                    if size.height > 0 && size.height >= cellBoundsHeight {
                        // +1 for the cell separator
                        return size.height + 1
                    } else {
                        // In some situations (such as the content view not having any/enough constraints to get a height), the
                        // size from the systemLayoutSizeFittingSize: will be 0. However, because this can _sometimes_ be intended
                        // (e.g., when adding to a default style; see: DynamicSubtitleTableViewCell), we just return
                        // the height of the cell as-is. This may make some cells look wrong, but overall will also prevent 0 being returned,
                        // hopefully stopping some things from breaking.
                        return cellBoundsHeight + 1
                    }
                }
            }
        }
        
        return UITableViewAutomaticDimension
    }
    
    /*
    In cells, iOS sorts out setting the height correctly, but not in iOS 7
    */
    
    // MARK: Setion Headers
    
    override public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let reuseIdentifier = self.headerViewReuseIdentifierForSection(section) {
            if let headerView = self.tableView.dequeueReusableHeaderFooterViewWithIdentifier(reuseIdentifier) as? UIView {
                return headerView
            }
        }
        return nil
    }
    
    func headerViewReuseIdentifierForSection(section: Int) -> String? {
        return nil
    }
    
    override public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let reuseIdentifier = self.headerViewReuseIdentifierForSection(section) {
            if let headerView = self.headerViewForReuseIdentifier(reuseIdentifier) {
                return headerView.calculateHeightInTableView(tableView)
            }
        }
        return UITableViewAutomaticDimension
    }
    
    // MARK: Setion Footers
    
    override public func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let reuseIdentifier = self.footerViewReuseIdentifierForSection(section) {
            if let footerView = self.tableView.dequeueReusableHeaderFooterViewWithIdentifier(reuseIdentifier) as? UIView {
                return footerView
            }
        }
        return nil
    }
    
    public func footerViewReuseIdentifierForSection(section: Int) -> String? {
        return nil
    }
    
    override public func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let reuseIdentifier = self.footerViewReuseIdentifierForSection(section) {
            if let footerView = self.footerViewForReuseIdentifier(reuseIdentifier) {
                return footerView.calculateHeightInTableView(tableView)
            }
        }
        return UITableViewAutomaticDimension
    }
    
    // MARK:- Private methods
    
    // MARK: Cell rows
    
    private func cellForReuseIdentifier(reuseIdentifier: String) -> UITableViewCell? {
        if self.offscreenCellRowsForReuseIdentifiers[reuseIdentifier] == nil {
            if let cellClass = self.cachedClassesForCellReuseIdentifiers[reuseIdentifier] {
                let cell = cellClass()

                self.offScreenWindow.addSubview(cell)
                self.offscreenCellRowsForReuseIdentifiers[reuseIdentifier] = cell
            } else if let cellNib = self.cachedNibsForCellReuseIdentifiers[reuseIdentifier] {
                if let cell = cellNib.instantiateWithOwner(nil, options: nil).first as? UITableViewCell {
                    self.offScreenWindow.addSubview(cell)
                    self.offscreenCellRowsForReuseIdentifiers[reuseIdentifier] = cell
                }
            }
        }
        return self.offscreenCellRowsForReuseIdentifiers[reuseIdentifier]
    }
    
    // MARK: Section Headers
    
    private func headerViewForReuseIdentifier(reuseIdentifier: String) -> DynamicTableViewHeaderFooterView? {
        if self.offscreenSectionHeadersForReuseIdentifiers[reuseIdentifier] == nil {
            if let cellClass = self.cachedClassesForSectionHeaderFooterReuseIdentifiers[reuseIdentifier] {
                let cell = cellClass()
                self.offscreenSectionHeadersForReuseIdentifiers[reuseIdentifier] = cell
            }
        }
        return self.offscreenSectionHeadersForReuseIdentifiers[reuseIdentifier]
    }
    
    // MARK: Section Footers
    
    private func footerViewForReuseIdentifier(reuseIdentifier: String) -> DynamicTableViewHeaderFooterView? {
        if self.offscreenSectionFootersForReuseIdentifiers[reuseIdentifier] == nil {
            if let cellClass = self.cachedClassesForSectionHeaderFooterReuseIdentifiers[reuseIdentifier] {
                let cell = cellClass()
                self.offscreenSectionFootersForReuseIdentifiers[reuseIdentifier] = cell
            }
        }
        return self.offscreenSectionFootersForReuseIdentifiers[reuseIdentifier]
    }
}
