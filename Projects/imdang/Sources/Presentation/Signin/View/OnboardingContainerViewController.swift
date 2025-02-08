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
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .pretenSemiBold(16)
        $0.backgroundColor = .mainOrange500
        $0.layer.cornerRadius = 8
    }
    
    private let backbutton = UIButton().then {
        $0.setImage(ImdangImages.Image(resource: .backButton), for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        addSubView()
        makeConstraints()
        bindActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backbutton)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    
    private func addSubView() {
        addChild(onboardingPageVC)
        [onboardingPageVC.view, nextButton].forEach(view.addSubview)
        onboardingPageVC.didMove(toParent: self)
    }
    
    private func makeConstraints() {
        onboardingPageVC.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-40)
            $0.height.equalTo(56)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    private func bindActions() {
        onboardingPageVC.crrentPageIndex
            .subscribe(with: self) { owner, value in
                owner.navigationItem.leftBarButtonItem?.customView?.isHidden = value == 0 ? false : true
            }
            .disposed(by: disposeBag)
        
            nextButton.rx.tap.subscribe(onNext: {
                self.onboardingPageVC.goToNextPage()
            }).disposed(by: disposeBag)
            
            backbutton.rx.tap.subscribe(onNext: {
                self.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
    }
}
