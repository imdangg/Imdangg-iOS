//
//  Requestable.swift
//  NetworkKit
//
//  Created by 임대진 on 11/25/24.
//

import Foundation

public import Alamofire

public typealias HTTPRequestParameter = [String: Any]

public protocol Requestable {
    
    associatedtype Response: Decodable
    
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders { get }
    var parameters: HTTPRequestParameter? { get }
    var encoding: ParameterEncoding { get }
    
    func makeURL() -> String
}

public extension Requestable {
    
    var encoding: ParameterEncoding {
        switch method {
            case .post, .put:
                return JSONEncoding.default
            default:
                return URLEncoding.default
        }
    }
    
    func makeURL() -> String {
        return "\(baseURL)\(path)"
    }
}
