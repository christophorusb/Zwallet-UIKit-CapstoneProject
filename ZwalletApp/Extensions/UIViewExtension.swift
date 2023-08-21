//
//  UIViewExtension.swift
//  ZwalletApp
//
//  Created by Christophorus Beneditto on 06/08/23.
//

import UIKit

extension UIView {
    func applyShadowedRoundedCard(cornerRadius: CGFloat = 40, shadowOpacity: Float = 0.1, shadowOffset: CGSize = CGSize(width: 0, height: -5), shadowRadius: CGFloat = 7) {

        self.layer.cornerRadius = cornerRadius
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]  // This will round only the top corners

        // Shadow settings
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = shadowOpacity  // Shadow opacity, you can change it to your need
        self.layer.shadowOffset = shadowOffset  // Shadow offset
        self.layer.shadowRadius = shadowRadius  // Shadow blur radius
    }
}

