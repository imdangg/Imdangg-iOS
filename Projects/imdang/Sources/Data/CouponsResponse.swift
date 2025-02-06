//
//  CuponsResponse.swift
//  imdang
//
//  Created by daye on 2/5/25.
//

import Foundation

struct CouponsResponse: Codable {
    var memberCouponId: Int?
    var couponCount: Int
    
    private enum CodingKeys: String, CodingKey {
        case memberCouponId
        case couponCount
    }
    
    // null 처리
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let id = try? container.decode(Int?.self, forKey: .memberCouponId) {
            self.memberCouponId = id
        } else {
            self.memberCouponId = nil
        }
        
        self.couponCount = try container.decode(Int.self, forKey: .couponCount)
    }
}
