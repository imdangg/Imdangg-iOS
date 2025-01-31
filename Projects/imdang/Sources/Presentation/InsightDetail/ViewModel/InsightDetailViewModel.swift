//
//  InsightDetailViewModel.swift
//  SharedLibraries
//
//  Created by 임대진 on 2/1/25.
//

import UIKit
import NetworkKit
import RxSwift
import Alamofire
import CoreLocation

struct InsightDetailResponse: Codable {
    let exchangeRequestId: String
}

final class InsightDetailViewModel {
    private var disposeBag = DisposeBag()
    private let networkManager = NetworkManager()

    func createInsight(thisInsightId: String, myInsightId: String) -> Observable<Bool> {
        let parameters: [String: Any] = [
            "requestedInsightId": thisInsightId,
            "requestMemberId": UserdefaultKey.memberId,
            "requestMemberInsightId": myInsightId,
            "memberCouponId": 0
        ]
        
        let endpoint = Endpoint<InsightDetailResponse>(
            baseURL: .imdangAPI,
            path: "/exchanges/request",
            method: .post,
            headers: [.contentType("application/json"), .authorization(bearerToken: UserdefaultKey.accessToken)],
            parameters: parameters
        )
        
        return networkManager.request(with: endpoint)
            .map { _ in
                return true
            }
            .catch { error in
                print("Error: \(error.localizedDescription)")
                return Observable.just(false)
            }
    }
}


