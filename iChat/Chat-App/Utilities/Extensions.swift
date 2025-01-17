//
//  Extensions.swift
//  Chat-App
//
//  Created by Aaryan Kothari on 04/04/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

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

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {

    func loadImageUsingCacheWithUrlString(urlString : String){
        
        self.image = nil
        
        //check cache for image
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }
        
        let url = URL(string: urlString)
         URLSession.shared.dataTask(with: url!) { (data, response, error) in
             if error != nil {
                 print(error?.localizedDescription ?? "")
             }
             else{
                 DispatchQueue.main.async {
                    if  let downloadedImage = UIImage(data: data!) {
                    
                        imageCache.setObject(downloadedImage, forKey: urlString as NSString)
    
                    self.image = downloadedImage
                    }
                 }
             }
         }.resume()
    }
}

extension UIViewController{
    func addIndent(_ textField : UITextField){
        let spacerView = UIView(frame:CGRect(x:0, y:0, width:10, height:textField.frame.height))
        textField.leftViewMode = UITextField.ViewMode.always
        textField.leftView = spacerView
    }
}

extension Int {
    var stringValue : String {
        return String(self)
    }
    
    var doubleValue : Double {
        return Double(self)
    }
    var intValue : Int {
        return Int(self)
    }
}

extension CGFloat {
    var negativeValue : CGFloat {
        return CGFloat(Float(self)*(-1))
    }
}

extension UIView{
    var globalPoint :CGPoint? {
        return self.superview?.convert(self.frame.origin, to: nil)
    }


    var globalFrame :CGRect? {
        return self.superview?.convert(self.frame, to: nil)
    }
}




extension UIAlertAction {
    var setAttributes: UIAlertAction{
        let action = self
        action.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        action.setValue(UIColor.label, forKey: "titleTextColor")
        return action
    }
}
    
extension Collection {
    func distance(to index: Index) -> Int { distance(from: startIndex, to: index) }
}

extension StringProtocol where Self: RangeReplaceableCollection {
    mutating func insert<S: StringProtocol>(separator: S, every n: Int) {
        for index in indices.dropFirst().reversed()
            where distance(to: index).isMultiple(of: n) {
            insert(contentsOf: separator, at: index)
        }
    }
    func inserting<S: StringProtocol>(separator: S, every n: Int) -> Self {
        var string = self
        string.insert(separator: separator, every: n)
        return string
    }
}

extension CGFloat{
    var timeStringFormatter : String {
        let format : String?
        let minutes = Int(self) / 60 % 60
        let seconds = Int(self) % 60
        if minutes < 60 {    format = "%01i:%02i"   }
        else {    format = "%01i:%02i"    }
        return String(format: format!, minutes, seconds)
    }
}

extension Double {
    var timeStringConverter: String {
        let timestampDate = NSDate(timeIntervalSince1970: self)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm"
       let time = dateFormatter.string(from: timestampDate as Date)
        return time
        }
}




