//
//  Colors.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 12/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

enum ColorAsset: String {
    case appTint
    case appTintExtraLight
    case appTintAlternate
    case backgroundColor
    case backgroundDullWhite
    case backgroundCell
    case btnBackWhite
    case btnBorder
    case textFieldTint
    case txtDark
    case txtGrey
    case txtLightGrey
    case txtTheme
    case txtExtraLight
    case txtWhite
    case txtMoreDark
    case btnWhiteTint
    case btnDarkTint
    case shadow
    case bannerBack
    case activityIndicator
    
    case Gradient0
    case Gradient1
    
    case requestCall
    case requestChat
    case requestHome
    case requestStatusAccept
    case requestStatusCompleted
    case requestStatusFailed
    case requestStatusInProgress
    case requestStatusPending
    case requestStatusNoAnswer
    case requestStatusBusy
    
    var color: UIColor {
        return UIColor.init(named: self.rawValue) ?? UIColor()
    }
}

extension UIColor {
    var hexString: String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        let multiplier = CGFloat(255.999999)

        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }

        if alpha == 1.0 {
            return String(
                format: "#%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier)
            )
        }
        else {
            return String(
                format: "#%02lX%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier),
                Int(alpha * multiplier)
            )
        }
    }
}
