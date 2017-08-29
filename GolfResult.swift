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
    
    static func calculateHcp( holePar: Int, holeIndex: Int, playerHcp: Int) -> Int {
        var hcp = holePar + (playerHcp / 18)
        if (playerHcp >= 0) {
            hcp += (playerHcp % 18 >= holeIndex ? 1 : 0);
        } else {
            hcp += (17 - (playerHcp % 18) <= holeIndex ? -1 : 0)
        }
        return hcp
    }
}
