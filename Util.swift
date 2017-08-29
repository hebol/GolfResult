//
//  Util.swift
//  TestGolf
//
//  Created by Martin Sjöblom on 2017-08-09.
//  Copyright © 2017 Martin Sjöblom. All rights reserved.
//

import Foundation

extension String
{
    func trim() -> String
    {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
}

func +<Key, Value> (lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
    var result = lhs
    rhs.forEach{ result[$0] = $1 }
    return result
}

extension UserDefaults {
    func setDefault(_ keyValues: [String:Any]) {
        keyValues.forEach { set($1, forKey: $0)}
    }
}
