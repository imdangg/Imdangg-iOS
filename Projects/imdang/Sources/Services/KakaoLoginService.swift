//
//  KakaoLoginService.swift
//  imdang
//
//  Created by 임대진 on 11/27/24.
//

import Foundation
import RxSwift
import RxKakaoSDKUser
import KakaoSDKUser
import KakaoSDKAuth
import Alamofire
import NetworkKit

class KakaoLoginService {
    static let shared = KakaoLoginService()
    
    private var disposeBag = DisposeBag()
    private let networkManager = NetworkManager()
    
    func signIn() -> Observable<Bool> {
        return UserApi.shared.rx.loginWithKakaoTalk()
            .flatMap { oauthToken in
                return self.getKakaoInfo(oauthToken: oauthToken)
                    .flatMap { profile in
                        guard profile != nil else {
                            return Observable.just(false)
                        }
                        
                        return self.sendKakaoInfoToServer(oauthToken: oauthToken)
                    }
            }
            .catchAndReturn(false)
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
    
    func sendKakaoInfoToServer(oauthToken: OAuthToken) -> Observable<Bool> {
        return Observable.create { [self] observer in
            
            let parameters: [String: Any] = [
                "accessToken": oauthToken.accessToken,
            ]
            let endpoint = Endpoint<User>(
                baseURL: .imdangAPI,
                path: "/auth/kakao",
                method: .post,
                parameters: parameters
            )
            
            networkManager.request(with: endpoint)
                .subscribe(
                    onNext: { entity in
                        UserdefaultKey.isJoined = entity.joined
                        UserdefaultKey.accessToken = entity.accessToken
                        UserdefaultKey.memberId = entity.memberId
                        observer.onNext(true)
                        observer.onCompleted()
                    },
                    onError: { error in
                        print("Request failed with error: \(error)")
                        observer.onNext(false)
                        observer.onCompleted()
                    }
                )
                .disposed(by: self.disposeBag)
            
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
