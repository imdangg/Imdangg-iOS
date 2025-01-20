//
//  Environment.swift
//  imdang
//
//  Created by 임대진 on 1/8/25.
//

import Foundation

struct Environment: Codable {
    var buildingCondition: [String]
    var security: [String]
    var childrenFacility: [String]
    var seniorFacility: [String]
    var text: String
    
    func conversionArray() -> [(String, [String])] {
        let allArrays: [(name: String, items: [String])] = [
            ("건물", buildingCondition),
            ("안전", security),
            ("어린이 시설", childrenFacility),
            ("경로 시설", seniorFacility)
        ]
        
        return allArrays
    }
}
