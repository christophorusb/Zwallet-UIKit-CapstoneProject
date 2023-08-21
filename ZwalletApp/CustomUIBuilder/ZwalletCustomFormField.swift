//
//  ZwalletCustomFormField.swift
//  ZwalletApp
//
//  Created by Christophorus Beneditto on 08/08/23.
//

import Foundation
import UIKit

/*
    subclass UITextField and override the layoutSubviews method, where we know the size of the text field, to set up the bottom border.
 
    the layoutSubviews method will be called whenever the size of the text field changes, so the bottom line will be positioned correctly.
 */
class ZwalletCustomTextField: UITextField {
    var bottomLine: CALayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if bottomLine == nil {
            bottomLine = CALayer()
            bottomLine.backgroundColor = UIColor.gray.cgColor
            layer.addSublayer(bottomLine)
        }
        
        bottomLine.frame = CGRect(x: 0, y: frame.height - 1, width: frame.width, height: 1)
    }
}
