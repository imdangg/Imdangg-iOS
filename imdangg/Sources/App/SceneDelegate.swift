import UIKit
 
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

            guard let windowScene = (scene as? UIWindowScene) else { return }
                
            window = UIWindow(windowScene: windowScene)
            window?.rootViewController = UserInfoEntryViewController()
            print("되냐?")
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
