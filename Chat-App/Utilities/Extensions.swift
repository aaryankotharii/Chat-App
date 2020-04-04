//
//  Extensions.swift
//  Chat-App
//
//  Created by Aaryan Kothari on 04/04/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat){
    self.init(red : r/255, green : g/255, blue: b/255, alpha: 1)
    }
}

extension UITextField {
    var cleanText : String{
        return self.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }
}
