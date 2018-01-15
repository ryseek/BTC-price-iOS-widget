//
//  File.swift
//  webScrapper
//
//  Created by ryseek on 29.09.2017.
//  Copyright © 2017 ryseek. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class DiffView : UIView {
    
//    @IBInspectable override var backgroundColor: UIColor?{
//        set { layer.backgroundColor = newValue?.cgColor}
//        get { return UIColor.init(cgColor:layer.backgroundColor!)}
//    }
    @IBInspectable var text : String?

    @IBInspectable var cornerRadius: CGFloat? {
        set { layer.cornerRadius = newValue ?? 0.0}
        get { return layer.cornerRadius}
    }
    
    @IBInspectable var borderColor: UIColor? {
        set { layer.borderColor = newValue?.cgColor  }
        get { return UIColor.init(cgColor: layer.borderColor!)}
    }
    
    @IBInspectable var borderWidth: CGFloat {
        set { layer.borderWidth = newValue }
        get { return layer.borderWidth }
    }
    override func draw(_ rect: CGRect) {
        let label = UILabel.init()
        label.text = text
        label.frame = rect
        label.textAlignment = .center
        label.textColor = UIColor.white
        self.backgroundColor = UIColor.red
        addSubview(label)
        setNeedsDisplay()
    }


}
