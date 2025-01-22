//
//  TermsModelViewController.swift
//  SharedLibraries
//
//  Created by 임대진 on 1/21/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxRelay

class TermsModelViewController: UIViewController {
    private var disposeBag = DisposeBag()
    private var countRelay = PublishRelay<Set<Int>>()
    private var currentSelected = Set<Int>()
    
    private let dimView = UIView().then {
        $0.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
    }
    
    private let modalView = UIView().then {
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
        $0.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
    }
    
    private let allCheckButton = CheckButton().then {
        $0.configure(isBackground: true, title: "전체 동의")
        $0.setState(isSelected: false)
    }
    
    private let termsButton = CheckButton().then {
        $0.configure(isBackground: false, title: "[필수] 이용약관")
        $0.setState(isSelected: false)
    }
    
    private let termsPageButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        $0.tintColor = .grayScale900
    }
    
    private let personalInfoButton = CheckButton().then {
        $0.configure(isBackground: false, title: "[필수] 개인 정보 수집 이용")
        $0.setState(isSelected: false)
    }
    
    private let personalInfoPageButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        $0.tintColor = .grayScale900
    }
    
    private let marketingButton = CheckButton().then {
        $0.configure(isBackground: false, title: "[필수] 마케팅 수신 및 앱 알림 동의")
        $0.setState(isSelected: false)
    }
    
    private let marketingPageButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        $0.tintColor = .grayScale900
//        $0.backgroundColor = .blue
    }
    
    private let acceptButton = CommonButton(title: "동의하고 계속하기", initialButtonType: .disabled)
    
    private let titleLabel = UILabel().then {
        $0.font = .pretenSemiBold(20)
        $0.textColor = .grayScale900
        $0.text = "서비스 이용 약관"
    }
    
    private let xButton = UIButton().then {
        $0.setImage(ImdangImages.Image(resource: .cancle), for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        makeConstraints()
        bindActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    private func addSubViews() {
        [dimView, modalView, allCheckButton, termsButton, personalInfoButton, marketingButton, acceptButton, titleLabel, xButton, termsPageButton, personalInfoPageButton, marketingPageButton].forEach { view.addSubview($0) }
    }
    
    private func makeConstraints() {
        dimView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        modalView.snp.makeConstraints {
            $0.height.equalTo(394)
            $0.width.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(28)
            $0.top.equalTo(modalView.snp.top).offset(24)
            $0.leading.equalToSuperview().offset(20)
        }
        
        xButton.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        allCheckButton.snp.makeConstraints {
            $0.height.equalTo(62)
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        termsButton.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.top.equalTo(allCheckButton.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalTo(termsPageButton.snp.leading).offset(-4)
        }
        
        personalInfoButton.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.top.equalTo(termsButton.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalTo(personalInfoPageButton.snp.leading).offset(-4)
        }
        marketingButton.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.top.equalTo(personalInfoButton.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalTo(marketingPageButton.snp.leading).offset(-4)
        }
        
        termsPageButton.snp.makeConstraints {
            $0.width.equalTo(9)
            $0.height.equalTo(12)
            $0.centerY.equalTo(termsButton.snp.centerY)
            $0.trailing.equalToSuperview().inset(36)
        }
        
        personalInfoPageButton.snp.makeConstraints {
            $0.width.equalTo(9)
            $0.height.equalTo(12)
            $0.centerY.equalTo(personalInfoButton.snp.centerY)
            $0.trailing.equalToSuperview().inset(36)
        }
        
        marketingPageButton.snp.makeConstraints {
            $0.width.equalTo(9)
            $0.height.equalTo(12)
            $0.centerY.equalTo(marketingButton.snp.centerY)
            $0.trailing.equalToSuperview().inset(36)
        }
        
        acceptButton.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().offset(-40)
        }
    }
    
    private func bindActions() {
        xButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
                if let rootNavController = self?.presentingViewController as? UINavigationController {
                    rootNavController.popToRootViewController(animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        allCheckButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                if currentSelected.count == 3 {
                    currentSelected = []
                    buttonProcessing(select: false)
                    allCheckButton.setState(isSelected: false)
                } else {
                    currentSelected = [0,1,2]
                    buttonProcessing(select: true)
                    allCheckButton.setState(isSelected: true)
                }
                countRelay.accept(currentSelected)
            })
            .disposed(by: disposeBag)
        
        termsButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                
                if currentSelected.contains(0) {
                    currentSelected.remove(0)
                    termsButton.setState(isSelected: false)
                } else {
                    currentSelected.insert(0)
                    termsButton.setState(isSelected: true)
                }
                countRelay.accept(currentSelected)
            })
            .disposed(by: disposeBag)
        
        termsPageButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                
                let webVC = WebViewController(url: "https://bit.ly/4jhcG2i")
                webVC.modalPresentationStyle = .formSheet
                self.present(webVC, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        personalInfoButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                
                if currentSelected.contains(1) {
                    currentSelected.remove(1)
                    personalInfoButton.setState(isSelected: false)
                } else {
                    currentSelected.insert(1)
                    personalInfoButton.setState(isSelected: true)
                }
                countRelay.accept(currentSelected)
            })
            .disposed(by: disposeBag)
        
        personalInfoPageButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                
                let webVC = WebViewController(url: "https://bit.ly/42juovZ")
                webVC.modalPresentationStyle = .formSheet
                self.present(webVC, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        marketingButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                
                if currentSelected.contains(2) {
                    currentSelected.remove(2)
                    marketingButton.setState(isSelected: false)
                } else {
                    currentSelected.insert(2)
                    marketingButton.setState(isSelected: true)
                }
                countRelay.accept(currentSelected)
            })
            .disposed(by: disposeBag)
        
        marketingPageButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                
                let webVC = WebViewController(url: "https://bit.ly/40o4Dbs")
                webVC.modalPresentationStyle = .formSheet
                self.present(webVC, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        acceptButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        countRelay
            .subscribe(onNext: { [weak self] arr in
                guard let self else { return }
                if arr.count == 3 {
                    acceptButton.setState(.enabled)
                } else {
                    acceptButton.setState(.disabled)
                    allCheckButton.setState(isSelected: false)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func buttonProcessing(select: Bool) {
        [termsButton, personalInfoButton, marketingButton].forEach {
            $0.setState(isSelected: select)
        }
    }
}
