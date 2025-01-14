//
//  ServerJoinService.swift
//  imdang
//
//  Created by 임대진 on 1/15/25.
//

import Foundation
import NetworkKit
import RxSwift

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
        let parameters: [String: Any] = [
            "nickname": nickname,
            "birthDate": birthDate,
            "gender": gender.rawValue,
            "deviceToken": UserdefaultKey.deviceToken
        ]
        
        let endpoint = Endpoint<JoinResponse>(
            baseURL: .imdangAPI,
            path: "/auth/join",
            method: .put,
            parameters: parameters
        )
        
        return networkManager.request(with: endpoint)
            .map { entity in
                print("Request succeeded with entity: \(entity)")
                return true
            }
            .catch { error in
                print("Request failed with error: \(error)")
                return Observable.just(false)
            }
    }
    
}

