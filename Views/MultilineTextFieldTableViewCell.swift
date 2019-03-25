//
//  MultilineTextFieldTableViewCell.swift
//  GardenLocator
//
//  Created by Michael Rommel on 25.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import UIKit

protocol ExpandingCellDelegate {
    func updateCellHeight(indexPath: NSIndexPath, comment: String)
}

class MultilineTextFieldTableViewCell: UITableViewCell {

    /// A UITextField
    open var textView = UITextView()
    
    var delegate: ExpandingCellDelegate?
    var cellIndexPath: NSIndexPath!
    
    var placeholderText = "Placeholder"
    var isEditMode = false
    let magicNumber = 748146

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
        self.contentView.viewWithTag(magicNumber)?.removeFromSuperview()
        self.textView.tag = magicNumber
        self.textView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.textView)
        self.addConstraint(NSLayoutConstraint(item: self.textView, attribute: .leading, relatedBy: .equal, toItem: self.contentView, attribute: .leading, multiplier: 1, constant: 8))
        self.addConstraint(NSLayoutConstraint(item: self.textView, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .top, multiplier: 1, constant: 8))
        self.addConstraint(NSLayoutConstraint(item: self.textView, attribute: .bottom, relatedBy: .equal, toItem: self.contentView, attribute: .bottom, multiplier: 1, constant: -8))
        self.addConstraint(NSLayoutConstraint(item: self.textView, attribute: .trailing, relatedBy: .equal, toItem: self.contentView, attribute: .trailing, multiplier: 1, constant: -16))
        self.textView.textAlignment = .left
        self.textView.delegate = self

        self.updateState()
    }

    func configure(textFieldValue: String, placeHolder: String) {

        self.placeholderText = placeHolder
        self.textView.text = textFieldValue
        self.updateState()
    }

    func textFieldValue() -> String {

        return self.textView.text ?? ""
    }

    /// UIView internal handler
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.textView.becomeFirstResponder()
    }

    func updateState() {

        if self.isEditMode {
            if self.textView.text == self.placeholderText {
                self.textView.text = nil
                self.textView.textColor = UIColor.black
            }
        } else {
            if textView.text.isEmpty {
                self.textView.text = self.placeholderText
                self.textView.textColor = UIColor.lightGray
            } else {
                self.textView.textColor = UIColor.black
            }
        }
    }
}

extension MultilineTextFieldTableViewCell: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        self.isEditMode = true
        self.updateState()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        self.isEditMode = false
        self.updateState()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.delegate?.updateCellHeight(indexPath: self.cellIndexPath, comment: textView.text)
    }
}
