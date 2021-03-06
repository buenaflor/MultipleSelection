//
//  BaseViews.swift
//  MultipleSelection
//
//  Created by Giancarlo on 02.06.18.
//  Copyright © 2018 Giancarlo Buenaflor. All rights reserved.
//

import UIKit

class Label: UILabel {
    
    init() {
        super.init(frame: .zero)
    }
    
    init(font: UIFont, textAlignment: NSTextAlignment, textColor: UIColor, numberOfLines: Int, breakMode: NSLineBreakMode? = nil) {
        super.init(frame: .zero)
        self.font = font
        self.numberOfLines = numberOfLines
        self.textAlignment = textAlignment
        self.textColor = textColor
        self.isUserInteractionEnabled = false
        if let breakMode = breakMode { self.lineBreakMode = breakMode }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
