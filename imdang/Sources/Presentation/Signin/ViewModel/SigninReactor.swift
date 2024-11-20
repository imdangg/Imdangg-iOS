//
//  SigninReactor.swift
//  imdang
//
//  Created by 임대진 on 11/13/24.
//

import ReactorKit
import RxSwift
import AuthenticationServices

final class SigninReactor: Reactor {
    
    struct State {
        var isKakaoSigninTapped: Bool = false
        var isGoogleSigninTapped: Bool = false
        var isAppleSigninTapped: Bool = false
        
        var appleLoginResult: Result<ASAuthorizationAppleIDCredential, Error>?
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
        
        case setAppleLoginResult(Result<ASAuthorizationAppleIDCredential, Error>)
    }
    
    let initialState = State()
    private let appleLoginService = AppleLoginService.shared

    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            case .tapKakaoButton:
                return Observable.just(.setKakaoSigninTapped(true))
            case .tapGoogleButton:
                return Observable.just(.setGoogleSigninTapped(true))
            case .tapAppleButton:
                print("tap apple")
                appleLoginService.startSignInWithApple()
                return appleLoginService.loginResult
                .map{Mutation.setAppleLoginResult($0) }
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
               
            case .setAppleLoginResult(let result):
                newState.appleLoginResult = result
        }
        
        return newState
    }
}

