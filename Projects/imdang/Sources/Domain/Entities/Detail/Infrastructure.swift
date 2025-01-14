//
//  Infrastructure.swift
//  imdang
//
//  Created by 임대진 on 1/8/25.
//

import Foundation

struct Infrastructure {
    let traffic: [String]
    let educationInfo: [String]
    let livingFacility: [String]
    let culturalAndLeisure: [String]
    let surroundEnvironment: [String]
    let landMark: [String]
    let repellentFacility: [String]
    let text: String
    
    func conversionArray() -> [(String, [String])] {
        let allArrays: [(name: String, items: [String])] = [
            ("교통", traffic),
            ("학군", educationInfo),
            ("생활 편의 시설", livingFacility),
            ("문화 및 여가시설 (단지외부)", culturalAndLeisure),
            ("주변환경", surroundEnvironment),
            ("랜드마크", landMark),
            ("기피 시설", repellentFacility)
        ]
        
        return allArrays
    }
}
