//
//  FavorableNews.swift
//  imdang
//
//  Created by 임대진 on 1/8/25.
//

import Foundation

struct FavorableNews {
    let transportations: [String]
    let developments: [String]
    let educations: [String]
    let environments: [String]
    let cultures: [String]
    let industries: [String]
    let policies: [String]
    let text: String
    
    func conversionArray() -> [(String, [String])] {
        let allArrays: [(name: String, items: [String])] = [
            ("교통", transportations),
            ("개발", developments),
            ("교육", educations),
            ("자연 환경", environments),
            ("문화", cultures),
            ("산업", industries),
            ("정책", policies)
        ]
        
        return allArrays
    }
}
