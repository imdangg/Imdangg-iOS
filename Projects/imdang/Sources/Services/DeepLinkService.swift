//
//  DeepLinkService.swift
//  imdang
//
//  Created by daye on 12/31/24.
//

import UIKit

// 사용법
// In AppDelegate
// let url = "/home/profile"
// DeepLinkManager.shared.handleDeeplink(url: url, window: window)

final class DeepLinkManager {
    static let shared = DeepLinkManager()

    private init() {}

    // URL 처리
    func handleDeeplink(url: URL, window: UIWindow?) {
        let path = url.path // ex: "/home/mypage"
        var pathComponents = path.split(separator: "/").map(String.init) // "/" 기준으로 분리
        print("받은 딥링크 경로: \(pathComponents)")

        // 첫 번째 부터 검사
        guard let firstComponent = pathComponents.first else {
            print("딥링크 경로가 비어 있습니다.")
            return
        }

        // 루트 뷰 컨트롤러 설정
        if let rootController = getController(name: firstComponent) {
            let navController = UINavigationController(rootViewController: rootController)
            changeRootView(navController, animated: true, window: window)
        } else {
            print("#####Unhandled root path: \(firstComponent)")
            return
        }

        // 첫 번째 요소를 처리했으므로 경로에서 제거
        pathComponents.removeFirst()

        // 나머지 경로를 처리
        if let rootNavController = window?.rootViewController as? UINavigationController {
            processPathComponents(pathComponents, from: rootNavController)
        } else {
            print("컨트롤러 없음")
        }
    }

    // 재귀로 앞에서부터 뒤로가면서 처리
    private func processPathComponents(_ components: [String], from currentController: UIViewController?) {
        guard !components.isEmpty else {
            print("경로 처리 완료")
            return // 모든 경로 처리 완
        }

        let currentPath = components.first! // 현재 처리할 경로
        let remainingComponents = Array(components.dropFirst()) // 나머지 경로

        guard let navController = currentController as? UINavigationController else {
            print("컨트롤러 없음")
            return
        }

        if let nextController = getController(name: currentPath) {
            // 현재 경로에 맞는 컨트롤러를 네비게이션 스택에 추가
            navController.pushViewController(nextController, animated: true)
            processPathComponents(remainingComponents, from: navController)
        } else {
            print("Unhandled path: \(currentPath)")
        }
    }

    // 컨트롤러 여기서 생성만 해주면 됨
    private func getController(name: String) -> UIViewController? {
        switch name {
        case "home":
            return TabBarController()
        case "mypage":
            return MyPageViewController(reactor: MyPageReactor())
        default:
            return nil
        }
    }

    // 이건 여기둬도 되고 씬에 둬도 되고,, 변경 가능
    private func changeRootView(_ viewController: UIViewController, animated: Bool, window: UIWindow?) {
        guard let window = window else { return }
        
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
