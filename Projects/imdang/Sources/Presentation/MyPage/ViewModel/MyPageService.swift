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
    
    func logout() -> Observable<Bool> {
        
        let endpoint = Endpoint<EmptyResponse>(
            baseURL: .imdangAPI,
            path: "/members/logout",
            method: .post,
            headers: [.contentType("application/json"), .authorization(bearerToken: UserdefaultKey.accessToken)]
        )
        return networkManager.requestOptional(with: endpoint)
            .map { response in
                UserdefaultKey.isSiginedIn = false
                return true
            }
            .catch { error in
                print("Logout request failed with error: \(error)")
                return Observable.just(false)
            }
    }
}
