//
//  HomeViewModel.swift
//  imdang
//
//  Created by 임대진 on 2/1/25.
//

import Foundation
import NetworkKit
import Alamofire
import RxSwift

struct TokenResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let expiresIn: Double
}

final class HomeViewModel {
    private var disposeBag = DisposeBag()
    private let networkManager = NetworkManager()
    
    func issueCoupons(id: String) -> Observable<Bool> {
        let parameters: [String: Any] = [
            "memberId": UserdefaultKey.memberId,
            "couponId": id,
        ]
        
        let endpoint = Endpoint<BasicResponse>(
            baseURL: .imdangAPI,
            path: "/coupons/issue",
            method: .post,
            headers: [.contentType("application/json"), .authorization(bearerToken: UserdefaultKey.accessToken)],
            parameters: parameters
        )
        
        return networkManager.requestOptional(with: endpoint)
            .map { _ in
                return true
            }
            .catch { error in
                print("Error: \(error.localizedDescription)")
                return Observable.just(false)
            }
    }
    
    func isTokenExpired() -> Bool {
        guard let savedTime = UserdefaultKey.expiresIn else { return false }
        let expirationTime: TimeInterval = 18000
        let currentTime = Date().timeIntervalSince1970

        return (currentTime - savedTime) >= expirationTime
    }
    
    func tokenReissue() -> Observable<Bool> {
        let parameters: [String: Any] = [
            "memberId": UserdefaultKey.memberId,
            "refreshToken": UserdefaultKey.refreshToken
        ]
        print("parameters : \(parameters)")
        
        let endpoint = Endpoint<TokenResponse>(
            baseURL: .imdangAPI,
            path: "/auth/reissue",
            method: .post,
            headers: [.contentType("application/json")],
            parameters: parameters
        )
        
        return networkManager.requestOptional(with: endpoint)
            .map { result in
                if let result = result {
                    UserdefaultKey.accessToken = result.accessToken
                    UserdefaultKey.refreshToken = result.refreshToken
                    UserdefaultKey.expiresIn = result.expiresIn
                }
                return true
            }
            .catch { error in
                print("Error: \(error.localizedDescription)")
                return Observable.just(false)
            }
    }
    
    func loadMyNickname() {
        let endpoint = Endpoint<UserDetail>(
            baseURL: .imdangAPI,
            path: "/members/detail",
            method: .get,
            headers: [.contentType("application/json"), .authorization(bearerToken: UserdefaultKey.accessToken)]
        )
        
        networkManager.request(with: endpoint)
            .subscribe { result in
                UserdefaultKey.memberNickname = result.nickname
            }
            .disposed(by: disposeBag)
    }
}
