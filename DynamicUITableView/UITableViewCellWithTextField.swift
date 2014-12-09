//
//  UITableViewCellWithTextField.swift
//  DynamicUITableView
//
//  Created by Joseph Duffy on 04/11/2014.
//  Copyright (c) 2014 Yetii Ltd. All rights reserved.
//

import UIKit

class UITableViewCellWithTextField: DynamicUITableViewCell {
    
    private var label: DynamicFontLabel!
    private(set) var textField: UITextField!
    override var textLabel: UILabel {
        get {
            return self.label
        }
    }
    private var didUpdateConstraints = false
    
    override func setup() {
        
        self.selectionStyle = .None
        
        self.label = DynamicFontLabel()
//        self.label = UILabel()
        self.label.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.textField = UITextField()
        self.textField.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.textField.borderStyle = .None
        self.textField.textAlignment = .Right
        // Setting this allows the text field to fill the space left by the label
        self.textField.setContentHuggingPriority(self.label.contentHuggingPriorityForAxis(.Horizontal) - 1, forAxis: .Horizontal)
        
        self.contentView.addSubview(self.label)
        self.contentView.addSubview(self.textField)
    }
    
    private func addConstraints() {
        self.label.autoPinEdge(.Top, toEdge: .Top, ofView: self.label.superview!, withOffset: self.verticleOffset, relation: .GreaterThanOrEqual)
        self.label.autoPinEdge(.Leading, toEdge: .Leading, ofView: self.label.superview!, withOffset: self.horizontalOffset, relation: .Equal)
        self.label.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self.label.superview!, withOffset: -self.verticleOffset, relation: .Equal)
        
        self.textField.autoAlignAxis(.Horizontal, toSameAxisOfView: self.label)
        self.textField.autoPinEdge(.Leading, toEdge: .Trailing, ofView: self.label, withOffset: 8, relation: .Equal)
        self.textField.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: self.textField.superview!, withOffset: -self.horizontalOffset, relation: .Equal)
    }
    
    override func updateConstraints() {
        if !self.didUpdateConstraints {
            self.addConstraints()            
            
            self.didUpdateConstraints = true
        }
        
        super.updateConstraints()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            self.textField.becomeFirstResponder()
        }
    }
    
    override func configureForContent(content: [String : AnyObject]) {
        super.configureForContent(content)
        if let textFieldText = content["textFieldText"] as? String {
            self.textField.text = textFieldText
        }
        if let textFieldTag = content["textFieldTag"] as? Int {
            self.textField.tag = textFieldTag
        }
        if let textFieldPlaceholder = content["textFieldPlaceholder"] as? String {
            self.textField.placeholder = textFieldPlaceholder
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.label.preferredMaxLayoutWidth = CGRectGetWidth(self.label.frame)
    }

}
