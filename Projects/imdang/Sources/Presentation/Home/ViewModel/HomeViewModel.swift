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
}
