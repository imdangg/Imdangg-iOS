//
//  SearchingViewModel.swift
//  imdang
//
//  Created by 임대진 on 1/24/25.
//

import Foundation
import NetworkKit
import Alamofire
import RxSwift

final class SearchingViewModel {
    var isLoading = false
    var myInsightTotalPage = 0
    var todayInsightTotalPage = 0
    private var disposeBag = DisposeBag()
    private let networkManager = NetworkManager()
    
    func loadInsights(page: Int, type: FullInsightType) -> Observable<[Insight]?> {
        let parameters: [String: Any] = [
            "pageNumber": 0,
            "pageSize": 10 * (page + 1),
            "direction": "ASC",
            "properties": [ "created_at" ]
        ]
        
        switch type {
        case .my:
            let endpoint = Endpoint<MyInsightResponse>(
                baseURL: .imdangAPI,
                path: "/my-insights/created-by-me",
                method: .get,
                headers: [.contentType("application/json"), .authorization(bearerToken: UserdefaultKey.accessToken)],
                parameters: parameters
            )
            
            return networkManager.request(with: endpoint)
                .map { data in
                    self.myInsightTotalPage = data.totalPages
                    return data.toEntitiy()
                }
                .catch { error in
                    print("Error: \(error.localizedDescription)")
                    return Observable.just(nil)
                }
        case .today:
            let endpoint = Endpoint<InsightResponse>(
                baseURL: .imdangAPI,
                path: "/insights",
                method: .get,
                headers: [.contentType("application/json"), .authorization(bearerToken: UserdefaultKey.accessToken)],
                parameters: parameters
            )
            
            return networkManager.request(with: endpoint)
                .map { data in
                    self.todayInsightTotalPage = data.totalPages
                    return data.toEntitiy()
                }
                .catch { error in
                    print("Error: \(error.localizedDescription)")
                    return Observable.just(nil)
                }
        case .search:
            return Observable.just(nil)
        }
    }
    
    func loadInsightDetail(id: String) -> Observable<InsightDetail?> {
        let parameters: [String: Any] = [
            "insightId": id
        ]
        
        let endpoint = Endpoint<InsightDetailResponse>(
            baseURL: .imdangAPI,
            path: "/insights/detail",
            method: .get,
            headers: [.contentType("application/json"), .authorization(bearerToken: UserdefaultKey.accessToken)],
            parameters: parameters
        )
        
        return networkManager.request(with: endpoint)
            .map { data in
                return data.toDetail()
            }
            .catch { error in
                print("Error: \(error.localizedDescription)")
                return Observable.just(nil)
            }
    }
}
