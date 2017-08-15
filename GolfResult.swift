//
//  GolfResult.swift
//  TestGolf
//
//  Created by Martin Sjöblom on 2017-08-15.
//  Copyright © 2017 Martin Sjöblom. All rights reserved.
//

import Foundation

class GolfResult {
    var results   = [String:[Int]]()
    var names     = [String]()
    var hcps      = [Float]()
    var courseHcp = [Int]()
    
    func hasStarted() -> Bool {
        return names.count > 0
    }
}
