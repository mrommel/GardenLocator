//
//  StringExtension.swift
//  GardenLocator
//
//  Created by Michael Rommel on 25.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import UIKit

extension String {
    func heightWithConstrained(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.height
    }
}
