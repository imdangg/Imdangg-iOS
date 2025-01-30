//
//  InsightResponse.swift
//  imdang
//
//  Created by 임대진 on 1/24/25.
//

import Foundation

struct MyInsightResponse: Codable {
    let totalElements: Int
    let totalPages: Int
    let size: Int
    let content: [MyInsightContent]
    let number: Int
    let sort: Sort
    let pageable: Pageable
    let numberOfElements: Int
    let first: Bool
    let last: Bool
    let empty: Bool
    
    func toEntitiy() -> [Insight] {
        return content.map {
            Insight(id: $0.insightId, titleName: $0.title, titleImageUrl: "", userName: "닉네임", profileImageUrl: "", adress: $0.address.toShortString(), likeCount: $0.recommendedCount ?? 0, state: .done)
        }
    }
}

struct MyInsightContent: Codable {
    let insightId: String
    let recommendedCount: Int?
    let address: Address
    let title: String
}

struct Sort: Codable {
    let empty: Bool
    let sorted: Bool
    let unsorted: Bool
}

struct Pageable: Codable {
    let offset: Int
    let sort: Sort
    let paged: Bool
    let pageNumber: Int
    let pageSize: Int
    let unpaged: Bool
}
