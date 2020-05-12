//
//  Message.swift
//  Chat-App
//
//  Created by Aaryan Kothari on 06/04/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit
import FirebaseAuth

class Message: NSObject {
    
    
    var fromId: String?
    var text : String?
    var timestamp : Int?
    var toId : String?
    
    var imageUrl : String?
    var videoUrl : String?
    var audioUrl : String?
    
    func chatPatnerId() -> String? {
        return fromId == getUID() ? toId : fromId
    }
}
