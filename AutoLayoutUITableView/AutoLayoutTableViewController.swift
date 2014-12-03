//
//  AutoLayoutTableViewController.swift
//  AutoLayoutUITableView
//
//  Created by Joseph Duffy on 03/12/2014.
//  Copyright (c) 2014 Yetii Ltd. All rights reserved.
//

import UIKit

class AutoLayoutTableViewController: UITableViewController {

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        println("Getting estimated height")
        if self.isiOS8OrGreater {
            return UITableViewAutomaticDimension
        } else {
            if let reuseIdentifier = self.reuseIdentifierForIndexPath(indexPath) {
                if let cellType = self.classForReuseIdentifier(reuseIdentifier) {
                    return cellType.estimatedHeight()
                } else {
                    return UITableViewAutomaticDimension
                }
            } else {
                return UITableViewAutomaticDimension
            }
        }
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        println("Getting actual height")
        if self.isiOS8OrGreater {
            return UITableViewAutomaticDimension
        } else {
            if let reuseIdentifier = self.reuseIdentifierForIndexPath(indexPath) {
                if let cell = self.cellForReuseIdentifier(reuseIdentifier) {
                    let content = self.contentForIndexPath(indexPath)
                    return cell.heightForContent(content)
                } else {
                    return UITableViewAutomaticDimension
                }
            } else {
                return UITableViewAutomaticDimension
            }
        }
    }

    // MARK:- Methods to be overrided

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let reuseIdentifier = self.reuseIdentifierForIndexPath(indexPath) {
            if let cell = self.tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as? UITableViewCell {
                if let cellContent = self.contentForIndexPath(indexPath) {
                    cell.configureForContent(cellContent)
                }
                return cell
            } else {
                fatalError("Could not dequeue a reusable cell for supplied reuse identifier: \(reuseIdentifier)")
            }
        } else {
            fatalError("Could not get a reuse identifier for section \(indexPath.section), row \(indexPath.row)")
        }
    }

    func reuseIdentifierForIndexPath(indexPath: NSIndexPath) -> String? {
        return nil
    }

    func contentForIndexPath(indexPath: NSIndexPath) -> [String : AnyObject]? {
        return nil
    }

    // MARK:- Private methods

    private var isiOS8OrGreater: Bool {
        get {
            return (UIDevice.currentDevice().systemVersion as NSString).floatValue >= 8.0
        }
    }

    private var cachedCellsForReuseIdentifiers = [String : UITableViewCell?]()

    private func cellForReuseIdentifier(reuseIdentifier: String) -> UITableViewCell? {
        if self.cachedCellsForReuseIdentifiers[reuseIdentifier] == nil {
            if let cell = self.tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as? UITableViewCell {
                self.cachedCellsForReuseIdentifiers[reuseIdentifier] = cell
            }
        }
        return self.cachedCellsForReuseIdentifiers[reuseIdentifier]!
    }

    private var cachedClassesForReuseIdentifiers = [String : UITableViewCell.Type?]()

    private func classForReuseIdentifier(reuseIdentifier: String) -> UITableViewCell.Type? {
        if self.cachedClassesForReuseIdentifiers[reuseIdentifier] == nil {
            if let cell = self.cellForReuseIdentifier(reuseIdentifier) {
                self.cachedClassesForReuseIdentifiers[reuseIdentifier] = cell.dynamicType
            }
        }
        return self.cachedClassesForReuseIdentifiers[reuseIdentifier]!
    }
}
