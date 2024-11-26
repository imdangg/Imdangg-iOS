//
//  Url +.swift
//  imdang
//
//  Created by 임대진 on 11/27/24.
//

import Foundation

extension URL {
    var queryParameters: [String: String]? {
        guard let query = self.query else { return nil }
        var parameters = [String: String]()
        for component in query.components(separatedBy: "&") {
            let pair = component.components(separatedBy: "=")
            if pair.count == 2 {
                parameters[pair[0]] = pair[1]
            }
        }
        return parameters
    }
}
