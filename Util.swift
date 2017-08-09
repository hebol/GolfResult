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
