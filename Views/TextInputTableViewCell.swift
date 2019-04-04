//
//  TextInputTableViewCell.swift
//  GardenLocator
//
//  Created by Michael Rommel on 17.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import UIKit

public class TextInputTableViewCell: UITableViewCell {
    
    /// A UITextField
    open var textField = UITextField()
    
    /// UIView initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    /// UIView initializer
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    /// UIView initializer
    override open func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    fileprivate func setup() {
        self.detailTextLabel?.isHidden = true
        self.contentView.viewWithTag(3)?.removeFromSuperview()
        self.textField.tag = 3
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.textField)
        self.addConstraint(NSLayoutConstraint(item: self.textField, attribute: .leading, relatedBy: .equal, toItem: self.contentView, attribute: .leading, multiplier: 1, constant: 50))
        self.addConstraint(NSLayoutConstraint(item: self.textField, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .top, multiplier: 1, constant: 8))
        self.addConstraint(NSLayoutConstraint(item: self.textField, attribute: .bottom, relatedBy: .equal, toItem: self.contentView, attribute: .bottom, multiplier: 1, constant: -8))
        self.addConstraint(NSLayoutConstraint(item: self.textField, attribute: .trailing, relatedBy: .equal, toItem: self.contentView, attribute: .trailing, multiplier: 1, constant: -16))
        self.textField.textAlignment = .right
    }
    
    func configure(title: String, textFieldValue: String, placeHolder: String) {
        
        self.textLabel?.text = title
        self.textField.text = textFieldValue
        self.textField.placeholder = placeHolder
    }
    
    func textFieldValue() -> String {
        
        return self.textField.text ?? ""
    }
}
