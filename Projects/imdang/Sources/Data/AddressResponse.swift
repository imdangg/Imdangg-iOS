//
//  AddressResponse.swift
//  imdang
//
//  Created by 임대진 on 2/2/25.
//

import Foundation

struct AddressResponse: Codable {
    var siDo: String
    var siGunGu: String
    var eupMyeonDong: String
    var apartmentComplexCount: Int
    var insightCount: Int
    
    func toAddress() -> String {
        return "\(siDo) \(siGunGu) \(eupMyeonDong)"
    }
    
    func toEupMyeonDongs() -> String {
        return "\(eupMyeonDong)"
    }
}
