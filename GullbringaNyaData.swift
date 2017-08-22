//
//  GullbringaNyaData.swift
//  TestGolf
//
//  Created by Martin Sjöblom on 2017-08-18.
//  Copyright © 2017 Martin Sjöblom. All rights reserved.
//

import Foundation

protocol GolfCourseData {
    static func getSlopeList() -> [[Float]]
    static func getHcpList() -> [Int]
    static func getParList() -> [Int]
}

class SaroPark54Data : GolfCourseData {
    static func getParList() -> [Int] {
        return [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3]
    }

    static func getHcpList() -> [Int] {
        return [11, 3, 7, 15, 5, 1, 17, 13, 9, 12, 4, 8, 16, 6, 2, 18, 14, 10]
    }

    static func getSlopeList() -> [[Float]] {
        return []
    }
}

class GullbringaNyaData : GolfCourseData {
    static func getSlopeList() -> [[Float]] {
        return [[-4, -3.7, -6],
         [-3.6, -2.8, -5],
         [-2.7, -1.8, -4],
         [-1.7, -0.9, -3],
         [-0.8, 0.0, -2],
         [0.1, 1.0, -1],
         [1.1, 1.9, 0],
         [2.0, 2.8, 1],
         [2.9, 3.8, 2],
         [3.9, 4.7, 3],
         [4.8, 5.6, 4],
         [5.7, 6.6, 5],
         [6.7, 7.5, 6],
         [7.6, 8.4, 7],
         [8.5, 9.4, 8],
         [9.5, 10.3, 9],
         [10.4, 11.2, 10],
         [11.3, 12.2, 11],
         [12.3, 13.1, 12],
         [13.2, 14.1, 13],
         [14.2, 15.0, 14],
         [15.1, 15.9, 15],
         [16.0, 16.9, 16],
         [17.0, 17.8, 17],
         [17.9, 18.7, 18],
         [18.8, 19.7, 19],
         [19.8, 20.6, 20],
         [20.7, 21.5, 21],
         [21.6, 22.5, 22],
         [22.6, 23.4, 23],
         [23.5, 24.3, 24],
         [24.4, 25.3, 25],
         [25.4, 26.2, 26],
         [26.3, 27.1, 27],
         [27.2, 28.1, 28],
         [28.2, 29.0, 29],
         [29.1, 29.9, 30],
         [30.0, 30.9, 31],
         [31.0, 31.8, 32],
         [31.9, 32.7, 33],
         [32.8, 33.7, 34],
         [33.8, 34.6, 35],
         [34.7, 35.5, 36],
         [35.6, 36.0, 37]]
    }
    
    static func getParList() -> [Int] {
        return[4,4,4,4,3,4,4,3,5,3,5,4,4,5,4,3,4,4]
    }
    
    static func getHcpList() -> [Int] {
        return  [15,7,5,13,11,3,17,9,1,18,4,8,2,12,16,10,6,14]
    }
}
