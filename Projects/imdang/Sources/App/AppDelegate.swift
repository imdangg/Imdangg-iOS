import UIKit
import RxKakaoSDKCommon

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        
        if let APIKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_APP_KEY") as? String {
            RxKakaoSDK.initSDK(appKey: APIKey)
        }
        
        return true
    }
}

