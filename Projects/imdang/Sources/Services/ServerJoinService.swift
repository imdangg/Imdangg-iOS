//
//  ServerJoinService.swift
//  imdang
//
//  Created by 임대진 on 1/15/25.
//

import Foundation
import NetworkKit
import RxSwift
import Alamofire

enum companyType {
    case google, kakao
}

struct JoinResponse: Codable {
    let code: String
    let message: String
}

class ServerJoinService {
    static let shared = ServerJoinService()
    
    private var disposeBag = DisposeBag()
    private let networkManager = NetworkManager()
    
    func joinImdang(nickname: String, birthDate: String, gender: Gender) -> Observable<Bool> {
        let parameters: [String: String] = [
            "nickname": nickname,
            "birthDate": birthDate,
            "gender": gender.rawValue,
            "deviceToken": UserdefaultKey.deviceToken
        ]
        
        print("parameters \(parameters)")
        print(UserdefaultKey.accessToken)
        
        let endpoint = Endpoint<JoinResponse>(
            baseURL: .imdangAPI,
            path: "/auth/join",
            method: .put,
            headers: [HTTPHeader(name: "Content-Type", value: "application/json"),
                      HTTPHeader(name: "Authorization", value: "Bearer \(UserdefaultKey.accessToken)")],
            parameters: parameters
        )
        
        return networkManager.request(with: endpoint)
            .map { entity in
                return true
            }
            .catch { error in
                return Observable.just(false)
            }
    }
}

