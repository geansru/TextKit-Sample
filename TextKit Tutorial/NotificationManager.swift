//
//  NotificationManager.swift
//  TextKit Tutorial
//
//  Created by Дмитрий on 16.12.15.
//  Copyright © 2015 Дмитрий. All rights reserved.
//

import UIKit

final class NotificationManager: Singletonable {
    static var sharedManager: NotificationManager = NotificationManager()
    func notifyOnSizeChanged(controller: UIViewController) {
        NSNotificationCenter.defaultCenter().addObserver(controller, selector: "preferredContentSizeChanged:", name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
}