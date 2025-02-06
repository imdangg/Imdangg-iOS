//
//  CouponService.swift
//  imdang
//
//  Created by daye on 2/7/25.
//

import Foundation
import NetworkKit
import RxSwift
import Alamofire

class CouponService {
    static let shared = CouponService()
    
    private var disposeBag = DisposeBag()
    private let networkManager = NetworkManager()
    
    // @discardableResult 써서 ID는 리턴하게 하려했는데 생각대로 안됨
    func getCoupons() -> Observable<Bool> {
        let endpoint = Endpoint<CouponsResponse>(
            baseURL: .imdangAPI,
            path: "/coupons",
            method: .get,
            headers: [.contentType("application/json"), .authorization(bearerToken: UserdefaultKey.accessToken)]
        )

        return networkManager.request(with: endpoint)
            .map { response in
                UserdefaultKey.couponCount = response.couponCount
                return true
            }
            .catch { error in
                print("Coupons request failed with error: \(error)")
                return Observable.empty()
            }
    }
    
}
