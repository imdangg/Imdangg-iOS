//
//  TabBarController.swift
//  imdang
//
//  Created by 임대진 on 11/13/24.
//

import UIKit
import SnapKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setValue(CustomTabBar(), forKey: "tabBar")
        UITabBar.appearance().backgroundColor = .white
        self.navigationItem.hidesBackButton = true
        
        configureTabBar()
        makeBoundaryLine()
        
        if let items = tabBar.items {
            for (index, item) in items.enumerated() {
                if index == 1 {
                    item.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -34, right: 0)
                } else {
                    item.titlePositionAdjustment = UIOffset(horizontal: index == 0 ? 20 : -20, vertical: 4)
                    item.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -16, right: 0)
                    item.setTitleTextAttributes([.font: UIFont.pretenRegular(12)], for: .normal)
                }
            }
        }
    }
    
    private func configureTabBar() {
        let firstViewController = HomeContainerViewController()
        let secondViewController = EmptyViewController(labelText: "작성뷰")
        let thirdViewController = EmptyViewController(labelText: "보관함")
        
        let firstNav = UINavigationController(rootViewController: firstViewController)
        let secondNav = UINavigationController(rootViewController: secondViewController)
        let thirdNav = UINavigationController(rootViewController: thirdViewController)
        
        firstNav.tabBarItem = UITabBarItem(title: "홈", image: ImdangImages.Image(resource: .tabHomeIcon), tag: 0)
        secondNav.tabBarItem = UITabBarItem(title: "", image: ImdangImages.Image(resource: .tabWritingIcon).withRenderingMode(.alwaysOriginal), tag: 1)
        thirdNav.tabBarItem = UITabBarItem(title: "보관함", image: ImdangImages.Image(resource: .tabSavedIcon), tag: 2)
        
        viewControllers = [firstNav, secondNav, thirdNav]
        
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = .gray
        tabBar.isTranslucent = false
    }
    
    private func makeBoundaryLine() {
        let topBorder = UIView()
        topBorder.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        
        tabBar.addSubview(topBorder)
        
        topBorder.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}

class CustomTabBar: UITabBar {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        size.height = 92
        return size
    }
}
