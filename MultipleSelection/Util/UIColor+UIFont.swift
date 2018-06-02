//
//  UIColor+UIFont.swift
//  MultipleSelection
//
//  Created by Giancarlo on 02.06.18.
//  Copyright © 2018 Giancarlo Buenaflor. All rights reserved.
//

import UIKit

private struct Default {
    static let font = UIFont.systemFont(ofSize: 16)
    static let color = UIColor.white
}

extension UIFont {
    
    public class var TempRegular: UIFont {
        return UIFont(name: "PingFangTC-Regular" , size: 16) ?? Default.font
    }
    public class var TempSemiBold: UIFont {
        return UIFont(name: "PingFangTC-Semibold", size: 16) ?? Default.font
    }
}

extension UIColor {
    
    public class var Background: UIColor {
        return UIColor(red:0.19, green:0.17, blue:0.21, alpha:1.0)
    }
    public class var DarkAccent: UIColor {
        return UIColor(red:0.12, green:0.12, blue:0.13, alpha:1.0)
    }
    public class var Highlight: UIColor {
        return UIColor(red:0.13, green:0.11, blue:0.15, alpha:1.0)
    }
    
}
