import UIKit
import RxKakaoSDKAuth
import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let viewController = SigninViewController()
        viewController.view.backgroundColor = .white
        
        let navigationController = UINavigationController(rootViewController: viewController)
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.rx.handleOpenUrl(url: url)
            }
        }
    }
  
    // 사용법 :
    // (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootView(UIViewController(), animated: true)
    /// 루트뷰 변경
    func changeRootView(_ viewController: UIViewController, animated: Bool) {
        guard let window = self.window else { return }
        
        if animated {
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromRight
            window.layer.add(transition, forKey: kCATransition)
        }
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
}
