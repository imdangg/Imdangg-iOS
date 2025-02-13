//
//  StorageResponse.swift
//  imdang
//
//  Created by 임대진 on 2/11/25.
//

import Foundation

struct StorageResponse: Codable {
    let number: Int
    let content: [StorageContent]
    let pageable: Pageable
    let sort: Sort
    let numberOfElements: Int
    let totalPages: Int
    let size: Int
    let last: Bool
    let empty: Bool
    let totalElements: Int
    let first: Bool
    
    func toEntitiy() -> [Insight] {
        return content.map {
            Insight(insightId: $0.insightId, titleName: $0.title, mainImageUrl: $0.mainImage ?? "", userName: $0.memberNickname, profileImageUrl: "", adress: $0.address.toShortString(), likeCount: $0.recommendedCount)
        }
    }
}

struct StorageContent: Codable {
    let mainImage: String?
    let memberNickname: String
    let title: String
    let recommendedCount: Int
    let insightId: String
    let address: Address
    let createdAt: String?
}
