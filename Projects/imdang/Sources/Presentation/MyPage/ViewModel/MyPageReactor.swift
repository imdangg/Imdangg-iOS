//
//  MyPageReactor.swift
//  imdang
//
//  Created by daye on 2/4/25.
//

import Foundation
import ReactorKit
import RxSwift

final class MyPageReactor: Reactor {
    
    private let myPageService = MyPageService.shared
    
    struct State {
        var myPageInfo: MyPageResponse?
        var isLogout: Bool = false
    }
    
    enum Action {
        case loadInfo
        case logout
    }
    
    enum Mutation {
        case setInfo(MyPageResponse)
        case setLogoutSuccess(Bool)
    }
    
    var initialState: State
    
    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadInfo:
            return myPageService.fetchMyPageInfo()
                .map { Mutation.setInfo($0) }
            
        case .logout:
            return myPageService.logout()
                .map { _ in Mutation.setLogoutSuccess(true) }
                .catch { error in
                    print("Logout failed with error: \(error)")
                    return Observable.just(Mutation.setLogoutSuccess(false))
                }
        }
        
        func reduce(state: State, mutation: Mutation) -> State {
            var newState = state
            
            switch mutation {
            case .setInfo(let info):
                newState.myPageInfo = info
                
            case .setLogoutSuccess(let success):
                newState.isLogout = success
            }
            
            return newState
        }
    }
}

