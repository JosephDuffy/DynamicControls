//
//  ExampleDynamicUITableViewController.swift
//  DynamicUITableView
//
//  Created by Joseph Duffy on 09/12/2014.
//  Copyright (c) 2014 Yetii Ltd. All rights reserved.
//

import UIKit

class ExampleDynamicUITableViewController: DynamicUITableViewController, UITextFieldDelegate {
   
    private var email: String!
    private var password: String!
    
    let loginSectionIndex = 0
    let emailRowIndex = 0
    let emailTextFieldTag = 1
    let passwordRowIndex = 1
    let passwordTextFieldTag = 2
    let loginButtonRowIndex = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Examples"
        self.tableView.keyboardDismissMode = .Interactive
        
        self.email = ""
        self.password = ""
        
        self.registerClass(UITableViewCellWithTextField.self, forCellReuseIdentifier: "CellWithTextField")
        self.registerClass(UITableViewCellAsButton.self, forCellReuseIdentifier: "CellAsButton")
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }
        fatalError("Cannot get number of rows for section \(section)")
    }
    
    override func cellReuseIdentifierForIndexPath(indexPath: NSIndexPath) -> String? {
        let section = indexPath.section
        let row = indexPath.row
        
        if section == self.loginSectionIndex {
            if row == self.emailRowIndex || row == self.passwordRowIndex {
                return "CellWithTextField"
            } else if row == self.loginButtonRowIndex {
                return "CellAsButton"
            }
        }
        
        return nil
    }
    
    override func cellContentForIndexPath(indexPath: NSIndexPath) -> [String : AnyObject]? {
        let section = indexPath.section
        let row = indexPath.row
        
        if section == self.loginSectionIndex {
            if row == self.emailRowIndex {
                return [
                    UITableViewCellContentKey.textLabelText.rawValue: "Email",
                    "textFieldText": self.email,
                    "textFieldTag": self.emailTextFieldTag,
                    "textFieldPlaceholder": "Required"
                ]
            } else if row == self.passwordRowIndex {
                return [
                    UITableViewCellContentKey.textLabelText.rawValue: "Password",
                    "textFieldText": self.password,
                    "textFieldTag": self.passwordTextFieldTag,
                    "textFieldPlaceholder": "Required"
                ]
            } else if row == self.loginButtonRowIndex {
                return [
                    UITableViewCellContentKey.textLabelText.rawValue: "Login"
                ]
            }
        }
        
        return nil
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        if section == self.loginSectionIndex {
            if row == self.emailRowIndex {
                let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath) as UITableViewCellWithTextField
                cell.textField.keyboardType = .EmailAddress
                cell.textField.addTarget(self, action: "textFieldEditingChanged:", forControlEvents: .EditingChanged)
                return cell
            } else if row == self.passwordRowIndex {
                let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath) as UITableViewCellWithTextField
                cell.textField.secureTextEntry = true
                cell.textField.addTarget(self, action: "textFieldEditingChanged:", forControlEvents: .EditingChanged)
                return cell
            } else if row == self.loginButtonRowIndex {
                let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath) as UITableViewCellAsButton
                // Here you would check if the email is valid and the password meetsyour requirements
                cell.enabled = !self.email.isEmpty && !self.password.isEmpty
                return cell
            }
        }
        
        return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
    }
    
    func textFieldEditingChanged(textField: UITextField) {
        switch textField.tag {
        case self.emailTextFieldTag:
            self.email = textField.text
            self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 2, inSection: 0)], withRowAnimation: .None)
        case self.passwordTextFieldTag:
            self.password = textField.text
            self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 2, inSection: 0)], withRowAnimation: .None)
        default:
            break
        }
    }
}
