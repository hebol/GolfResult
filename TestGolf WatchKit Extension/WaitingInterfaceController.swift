//
//  WaitingInterfaceController.swift
//  TestGolf
//
//  Created by Martin Sjöblom on 2017-08-11.
//  Copyright © 2017 Martin Sjöblom. All rights reserved.
//

import WatchKit
import Foundation
import UIKit

class WaitingInterfaceController: WKInterfaceController {
    let notification = Notification.Name(rawValue:"ScoreNotification")
    
    override init() {
        super.init()
       
        NotificationCenter.default.addObserver(forName:notification, object:nil, queue:nil, using:scoreNotification)
    }
    
    func scoreNotification(notification:Notification) -> Void {
        WKInterfaceDevice.current().play(WKHapticType.success)
        self.popToRootController()
    }
}
