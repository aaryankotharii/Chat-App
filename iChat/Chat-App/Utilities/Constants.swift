//
//  Constants.swift
//  Chat-App
//
//  Created by Aaryan Kothari on 20/04/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import Foundation
import Firebase

//MARK: -  function to get uid
internal func getUID() -> String {
    let uid = Auth.auth().currentUser?.uid
    return uid ?? "notFound"
}


public func debugLog(message: String) {
    #if DEBUG
    debugPrint("=======================================")
    debugPrint(message)
    debugPrint("=======================================")
    #endif
}
