//
//  MyPageService.swift
//  imdang
//
//  Created by daye on 2/4/25.
//

import RxSwift
import NetworkKit

class MyPageService {
    
    private let networkManager = NetworkManager()
    static let shared = MyPageService()
    
    func fetchMyPageInfo() -> Observable<MyPageResponse> {
        
        let endpoint = Endpoint<MyPageResponse>(
            baseURL: .imdangAPI,
            path: "/members/detail",
            method: .get,
            headers: [.contentType("application/json"), .authorization(bearerToken: UserdefaultKey.accessToken)]
        )

        return networkManager.request(with: endpoint)
            .map { response in
                return response
            }
            .catch { error in
                print("MyPage request failed with error: \(error)")
                return Observable.empty()
            }
    }
}
