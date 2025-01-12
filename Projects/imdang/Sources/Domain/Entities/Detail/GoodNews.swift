//
//  GoodNews.swift
//  imdang
//
//  Created by 임대진 on 1/8/25.
//

import Foundation

struct GoodNews {
    let traficNews: [String]
    let develop: [String]
    let education: [String]
    let naturalEnvironment: [String]
    let culture: [String]
    let industry: [String]
    let policy: [String]
    let text: String
    
    func conversionArray() -> [(String, [String])] {
        let allArrays: [(name: String, items: [String])] = [
            ("교통", traficNews),
            ("개발", develop),
            ("교육", education),
            ("자연 환경", naturalEnvironment),
            ("문화", culture),
            ("산업", industry),
            ("정책", policy)
        ]
        
        return allArrays
    }
}
