//
//  UserInfoEntryReactor.swift
//  imdang
//
//  Created by daye on 11/14/24.
//


import Foundation
import ReactorKit

class UserInfoEntryReactor: Reactor {
    
    struct State {
        var loginResult: Bool
        
        var submitButtonEnabled: CommonButtonState
    }
    
    // v -> r
    enum Action {
        case submmited(String)
        
        case submitButtonTapped
    }
    
    // r -> v
    enum Mutation {
        case isloginSusses(Bool)
    }
    
    var initialState: State
    
    init() {
        self.initialState = State(loginResult: false,
                                  submitButtonEnabled: .enabled)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .submmited(let id):
            return Observable.just(.isloginSusses(id.isEmpty ? false : true))
        
        case .submitButtonTapped:
            print("tap")
            return Observable.just(.isloginSusses(true))
        }
    
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .isloginSusses:
            print("로그인 성공")
            state.submitButtonEnabled = .disabled
        }
        
        return state
    }
}
