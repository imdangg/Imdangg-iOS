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

class KakaoLoginService {
    static let shared = KakaoLoginService()
    var disposeBag = DisposeBag()
    
    func signIn() -> Observable<Bool> {
        return UserApi.shared.rx.loginWithKakaoTalk()
            .flatMap { oauthToken in
                return self.getKakaoInfo(oauthToken: oauthToken)
                    .flatMap { profile in
                        guard profile != nil else {
                            return Observable.just(false) // 프로필정보 없으면 실패
                        }
                        
                        //                        return self.sendKakaoInfoToServer(oauthToken: oauthToken)
                        //                            .map { _ in
                        //                                return Mutation.setKakaoSigninSuccess(true) // 서버 전송 성공 시 로그인 성공 처리
                        //                            }
                        return Observable.just(true)
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
