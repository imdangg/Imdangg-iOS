//
//  OnboardingPageViewController.swift
//  imdang
//
//  Created by 임대진 on 11/13/24.
//

import UIKit

class OnboardingPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    private let pages: [UIViewController]
    private var pageControl = UIPageControl()
    
    init() {
        let page1 = OnboardingViewController(title: "가이드로 인사이트 작성하기", description: "가이드라인으로 체계화된 인사이트를\n간편하게 작성할 수 있어요")
        let page2 = OnboardingViewController(title: "인사이트 교환하기", description: "양질의 인사이트를 주고받으며\n가치 있는 임장 인사이트를 교환하세요")
        let page3 = OnboardingViewController(title: "다양한 인사이트 모으기", description: "작성한 인사이트와 교환한 인사이트를\n보관함에서 편리하게 관리하세요")
        
        pages = [page1, page2, page3]
        
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        dataSource = self
        delegate = self
        
        if let firstVC = pages.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        
        setupPageControl()
    }
    
    private func setupPageControl() {
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .orange
        
        view.addSubview(pageControl)
        
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(super.view.snp.top).offset(36)
        }
    }
    
    func goToNextPage() {
        if let currentVC = viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentVC) {
            if currentIndex + 1 < pages.count {
                let nextVC = pages[currentIndex + 1]
                setViewControllers([nextVC], direction: .forward, animated: true, completion: nil)
                pageControl.currentPage += 1
            } else {
                let vc = UserInfoEntryViewController(reactor: UserInfoEntryReactor())
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController), currentIndex > 0 else {
            return nil
        }
        return pages[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController), currentIndex < pages.count - 1 else {
            return nil
        }
        return pages[currentIndex + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let visibleVC = viewControllers?.first, let index = pages.firstIndex(of: visibleVC) {
            pageControl.currentPage = index
        }
    }
}
