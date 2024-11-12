//
//  SigninReactor.swift
//  imdang
//
//  Created by 임대진 on 11/13/24.
//

import ReactorKit
import RxSwift

final class SigninReactor: Reactor {
    struct State {
        var isKakaoSigninTapped: Bool = false
        var isGoogleSigninTapped: Bool = false
        var isAppleSigninTapped: Bool = false
    }
    
    enum Action {
        case tapKakaoButton
        case tapGoogleButton
        case tapAppleButton
    }
    
    enum Mutation {
        case setKakaoSigninTapped(Bool)
        case setGoogleSigninTapped(Bool)
        case setAppleSigninTapped(Bool)
    }
    
    let initialState = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            case .tapKakaoButton:
                return Observable.just(.setKakaoSigninTapped(true))
            case .tapGoogleButton:
                return Observable.just(.setGoogleSigninTapped(true))
            case .tapAppleButton:
                return Observable.just(.setAppleSigninTapped(true))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
            case .setKakaoSigninTapped(let isTapped):
                newState.isKakaoSigninTapped = isTapped
            case .setGoogleSigninTapped(let isTapped):
                newState.isGoogleSigninTapped = isTapped
            case .setAppleSigninTapped(let isTapped):
                newState.isAppleSigninTapped = isTapped
        }
        
        return newState
    }
}

