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
    }

    enum Action {
        case loadInfo
    }

    enum Mutation {
        case setInfo(MyPageResponse)
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
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .setInfo(let info):
            newState.myPageInfo = info
        }

        return newState
    }
}
