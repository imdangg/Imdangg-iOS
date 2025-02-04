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

enum RecommendResult {
    case success
    case failure
    case recommended
    case beforeExchange
}

struct ExchangeResponse: Codable {
    let exchangeRequestId: String
}

struct InsightIDResponse: Codable {
    let insightId: String
}

final class InsightDetailViewModel {
    private var disposeBag = DisposeBag()
    private let networkManager = NetworkManager()
    
    func requestInsight(thisInsightId: String, myInsightId: String) -> Observable<Bool> {
        let parameters: [String: Any] = [
            "requestedInsightId": thisInsightId,
            "requestMemberId": UserdefaultKey.memberId,
            "requestMemberInsightId": myInsightId,
            "memberCouponId": UserdefaultKey.couponCount == nil ? "null" : UserdefaultKey.couponCount!
        ]
        
        let endpoint = Endpoint<ExchangeResponse>(
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
    
    func acceptInsight(exchangeRequestId: String) -> Observable<Bool> {
        let parameters: [String: Any] = [
            "exchangeRequestId": exchangeRequestId,
            "requestedMemberId": UserdefaultKey.memberId
        ]
        
        let endpoint = Endpoint<ExchangeResponse>(
            baseURL: .imdangAPI,
            path: "/exchanges/reject",
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
    
    func rejecttInsight(exchangeRequestId: String) -> Observable<Bool> {
        let parameters: [String: Any] = [
            "exchangeRequestId": exchangeRequestId,
            "requestedMemberId": UserdefaultKey.memberId
        ]
        
        let endpoint = Endpoint<InsightIDResponse>(
            baseURL: .imdangAPI,
            path: "/exchanges/reject",
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
    
    func recommendInsight(insightId: String) -> Observable<RecommendResult> {
        let parameters: [String: Any] = [
            "insightId": insightId,
            "recommendMemberId": UserdefaultKey.memberId
        ]
        
        let endpoint = Endpoint<InsightIDResponse>(
            baseURL: .imdangAPI,
            path: "/insights/recommend",
            method: .post,
            headers: [.contentType("application/json"), .authorization(bearerToken: UserdefaultKey.accessToken)],
            parameters: parameters
        )
        
        return networkManager.requestOptional(with: endpoint)
            .map { _ in
                return .success
            }
            .catch { error in
                if let nsError = error as NSError? {
                    if nsError.domain == "ALREADY_RECOMMENDED" {
                        return Observable.just(.recommended)
                    } else if nsError.domain == "EXCHANGE_REQUIRED" {
                        return Observable.just(.beforeExchange)
                    } else {
                        return Observable.just(.failure)
                    }
                }
                return Observable.just(.failure)
            }
    }
    
    func accueInsight(insightId: String) -> Observable<Bool> {
        let parameters: [String: Any] = [
            "insightId": insightId,
            "accuseMemberId": UserdefaultKey.memberId
        ]
        
        let endpoint = Endpoint<ExchangeResponse>(
            baseURL: .imdangAPI,
            path: "/insights/accue",
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


