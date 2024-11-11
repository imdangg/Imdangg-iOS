import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let viewController = SigninView()
        viewController.view.backgroundColor = .white
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        
    }
    //    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    //        guard let windowScene = (scene as? UIWindowScene) else { return }
    //        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
    //        window?.windowScene = windowScene
    //
    //        let viewController = UIViewController()
    //        viewController.view.backgroundColor = .orange
    //
    //        window?.rootViewController = viewController
    //        window?.makeKeyAndVisible()
    //    }
}
