//
//  Environment.swift
//  imdang
//
//  Created by 임대진 on 1/8/25.
//

import Foundation

struct Environment {
    let building: String
    let safety: String
    let childrenFacility: String
    let seniorFacility: String
    let text: String
    
    func conversionArray() -> [(String, [String])] {
        let allArrays: [(name: String, items: [String])] = [
            ("건물", [building]),
            ("안전", [safety]),
            ("어린이 시설", [childrenFacility]),
            ("경로 시설", [seniorFacility])
        ]
        
        return allArrays
    }
}
