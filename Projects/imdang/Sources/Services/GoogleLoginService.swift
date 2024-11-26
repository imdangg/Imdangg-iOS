//
//  GoogleLoginService.swift
//  imdang
//
//  Created by 임대진 on 11/27/24.
//

// GoogleLoginService.swift
import RxSwift
import GoogleSignIn

class GoogleLoginService {
    static let shared = GoogleLoginService()
    
    func signIn() -> Observable<Bool> {
        return Observable.create { observer in
            guard let rootViewController = UIApplication.shared.currentRootViewController else {
                observer.onError(NSError(domain: "GoogleSignIn", code: -1, userInfo: [NSLocalizedDescriptionKey: "No root view controller available"]))
                observer.onCompleted()
                return Disposables.create()
            }
            
            GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { signInResult, error in
                if let error = error {
                    print("Google sign-in error: \(error)")
                    observer.onNext(false)
                } else {
                    print("Google sign-in success: \(signInResult?.user.profile?.name ?? "")")
                    observer.onNext(true)
                }
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
}

