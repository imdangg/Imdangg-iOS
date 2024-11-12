//
//  OnboardingContainerViewController.swift
//  imdang
//
//  Created by 임대진 on 11/13/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class OnboardingContainerViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let onboardingPageVC = OnboardingPageViewController()
    private let nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.backgroundColor = .orange
        $0.layer.cornerRadius = 8
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        self.navigationItem.hidesBackButton = true
        
        addSubView()
        makeConstraints()
        configButton()
    }
    
    private func addSubView() {
        addChild(onboardingPageVC)
        [onboardingPageVC.view, nextButton].forEach(view.addSubview)
        onboardingPageVC.didMove(toParent: self)
    }
    
    private func makeConstraints() {
        onboardingPageVC.view.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(289)
            $0.width.equalTo(view.snp.width)
        }
        
        nextButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-40)
            $0.height.equalTo(56)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    private func configButton() {
        nextButton.rx.tap.subscribe(onNext: {
            self.onboardingPageVC.goToNextPage()
        }).disposed(by: disposeBag)
    }
}
