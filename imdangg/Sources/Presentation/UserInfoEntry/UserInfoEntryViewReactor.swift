//
//  UserInfoEntryReactor.swift
//  imdangg
//
//  Created by daye on 11/11/24.
//

import Foundation
import ReactorKit

class UserInfoEntryViewReactor: Reactor {
    
    // v -> r
    enum Action {
        case submmited(String)
    }
    
    // r -> v
    enum Mutation {
        case isloginSusses(Bool)
    }
    
    struct State {
        var loginResult: Bool
    }
    
    var initialState: State
    
    init() {
        self.initialState = State(loginResult: false)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .submmited(let id):
            return Observable.just(.isloginSusses(id.isEmpty ? false : true))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .isloginSusses:
            state.loginResult = true
        }
        
        return state
    }
}
