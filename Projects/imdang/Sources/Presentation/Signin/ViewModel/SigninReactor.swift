//
//  SigninReactor.swift
//  imdang
//
//  Created by 임대진 on 11/13/24.
//

import Alamofire
import Foundation
import RxSwift
import AuthenticationServices
import ReactorKit
import RxKakaoSDKUser
import KakaoSDKUser
import KakaoSDKAuth

enum ServerAuthError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case parsingError
    case serverClosed
}

final class SigninReactor: Reactor {
    let disposeBag = DisposeBag()
    
    struct State {
        var isKakaoSigninTapped: Bool = false
        var isGoogleSigninTapped: Bool = false
        var isAppleSigninTapped: Bool = false

        // 변경될수도?
        var appleLoginResult: Result<ASAuthorizationAppleIDCredential, Error>?
        var isKakaoSigninSuccess: Bool = false
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
        case setKakaoSigninSuccess(Bool)
    }
    
    let initialState = State()
    private let appleLoginService = AppleLoginService.shared

    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .tapKakaoButton:
            return kakaoSignIn()
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
            case .setKakaoSigninSuccess(let isSuccess):
                newState.isKakaoSigninSuccess = isSuccess
        }
        
        return newState
    }
    
    func kakaoSignIn() -> Observable<Mutation> {
        return UserApi.shared.rx.loginWithKakaoTalk()
            .flatMap { oauthToken in
                return self.getKakaoInfo(oauthToken: oauthToken)
                    .flatMap { profile in
                        guard profile != nil else {
                            return Observable.just(Mutation.setKakaoSigninSuccess(false)) // 프로필정보 없으면 실패
                        }
                        
                        //                        return self.sendKakaoInfoToServer(oauthToken: oauthToken)
                        //                            .map { _ in
                        //                                return Mutation.setKakaoSigninSuccess(true) // 서버 전송 성공 시 로그인 성공 처리
                        //                            }
                        return Observable.just(Mutation.setKakaoSigninSuccess(true))
                    }
            }
            .catchAndReturn(Mutation.setKakaoSigninSuccess(false))
    }
    
    func getKakaoInfo(oauthToken: OAuthToken) -> Observable<Profile?> {
        return UserApi.shared.rx.me()
            .asObservable()
            .map { user in
                return user.kakaoAccount?.profile
            }
            .catch { error in
                print("Error in getKakaoInfo: \(error)")
                return Observable.just(nil)
            }
    }
    
    func sendKakaoInfoToServer(oauthToken: OAuthToken) -> Observable<Void> {
        return Observable.create { observer in
            
            let url = "https://www.info.imdang"
            
            let parameters: [String: Any] = [
                "accessToken": oauthToken.accessToken,
                "refreshToken": oauthToken.refreshToken,
                "firebaseToken": "firebaseToken",
            ]
            
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json", "accept": "application/json"])
                .validate(statusCode: 200..<300)
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        do {
                            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                                observer.onError(ServerAuthError.parsingError)
                                return
                            }
                            
                            guard let accessToken = json["accessToken"] as? String,
                                  let refreshToken = json["refreshToken"] as? String else {
                                observer.onError(ServerAuthError.parsingError)
                                return
                            }
                            
                            observer.onNext(())
                            observer.onCompleted()
                        } catch {
                            observer.onError(ServerAuthError.parsingError)
                        }
                        
                    case .failure(let error):
                        print("sendKakaoInfoToServer failed with error: \(error.localizedDescription)")
                        observer.onError(error)
                    }
                }
            
            return Disposables.create()
        }
    }
    
    func kakaoLogout() {
        UserApi.shared.rx.logout()
            .subscribe(onCompleted:{
                print("logout() success.")
            }, onError: {error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
    
    func kakaoUnlink() {
        UserApi.shared.rx.unlink()
            .subscribe(onCompleted:{
                print("unlink() success.")
            }, onError: {error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
}
