//
//  Singletonable.swift
//  TextKit Tutorial
//
//  Created by Дмитрий on 16.12.15.
//  Copyright © 2015 Дмитрий. All rights reserved.
//

import Foundation

protocol Singletonable {
    static var sharedManager: Self { get }
}