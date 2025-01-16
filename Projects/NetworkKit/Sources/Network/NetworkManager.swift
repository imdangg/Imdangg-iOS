//
//  NetworkManager.swift
//  NetworkKit
//
//  Created by 임대진 on 11/25/24.
//

import Foundation
import RxSwift
public import Alamofire

public final class NetworkManager: Network {
    var session: Session
    
    public init(session: Session = Session(eventMonitors: [APIEventMonitor()])) {
        self.session = session
    }
    
    public func request<E: Requestable>(with endpoint: E) -> Observable<E.Response> {
        return Observable.create { [weak self] observer in
            guard let self = self else {
                observer.onError(NSError(domain: "Network Error", code: -1, userInfo: nil))
                return Disposables.create()
            }
            
            let request = self.session.request(endpoint.makeURL(),
                                               method: endpoint.method,
                                               parameters: endpoint.parameters,
                                               encoding: endpoint.encoding,
                                               headers: endpoint.headers)
                .validate()
                .responseDecodable(of: E.Response.self) { response in
                    switch response.result {
                    case .success(let data):
                        observer.onNext(data)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
