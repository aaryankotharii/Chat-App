//
//  Gestures.swift
//  Chat-App
//
//  Created by Aaryan Kothari on 16/04/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit

protocol GesutreDelegate {
    func onStart()
    func onEnd()
}


class iGesutreRecognizer: UIGestureRecognizer {
    var gestureDelegate: GesutreDelegate?


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        gestureDelegate?.onStart()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        gestureDelegate?.onEnd()
    }

}
