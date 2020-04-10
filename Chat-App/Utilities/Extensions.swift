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


extension UIAlertAction {
    var setAttributes: UIAlertAction{
        let action = self
        action.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        action.setValue(UIColor.black, forKey: "titleTextColor")
        return action
    }
}
    



