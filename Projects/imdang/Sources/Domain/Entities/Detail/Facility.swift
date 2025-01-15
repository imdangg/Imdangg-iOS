//
//  Facility.swift
//  imdang
//
//  Created by 임대진 on 1/8/25.
//

import Foundation

struct Facility {
    let family: [String]
    let multipurpose: [String]
    let leisure: [String]
    let environment: [String]
    let text: String
    
    func conversionArray() -> [(String, [String])] {
        let allArrays: [(name: String, items: [String])] = [
            ("가족", family),
            ("다목적", multipurpose),
            ("여가 (단지내부)", leisure),
            ("환경", environment)
        ]
        
        return allArrays
    }
}
