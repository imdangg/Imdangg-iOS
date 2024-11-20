//
//  SigninView.swift
//  imdang
//
//  Created by 임대진 on 11/11/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Then

final class SigninViewController: UIViewController {
    let disposeBag = DisposeBag()
    let reactor = SigninReactor()
    
    let kakaoButton = UIButton().then {
        $0.backgroundColor = UIColor(red: 1.0, green: 0.89, blue: 0.0, alpha: 1.0)
        $0.setTitle("카카오 로그인", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .pretenRegular(16)
        
        $0.layer.cornerRadius = 8
    }
    
    let googleButton = UIButton().then {
        $0.backgroundColor = .white
        $0.setTitle("구글 로그인", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .pretenRegular(16)
        
        $0.layer.cornerRadius = 8
        
        $0.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        $0.layer.borderWidth = 1
    }
    
    let appleButton = UIButton().then {
        $0.backgroundColor = .black
        $0.setTitle("애플 로그인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .pretenRegular(16)
        
        $0.layer.cornerRadius = 8
    }
    
    let imdangLogo = UIImageView().then {
        $0.image = ImdangImages.Image(resource: .imdangLogo)
    }
    let kakaoLogo = UIImageView().then {
        $0.image = ImdangImages.Image(resource: .kakaoLogo)
    }
    let googleLogo = UIImageView().then {
        $0.image = ImdangImages.Image(resource: .googleLogo)
    }
    let appleLogo = UIImageView().then {
        $0.image = ImdangImages.Image(resource: .appleLogo)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configButtons()
        addSubView()
        makeConstraints()
        bind(reactor: reactor)
    }
    
    private func configButtons() {
        let vc = OnboardingContainerViewController()
        
        googleButton.rx.tap.subscribe(onNext: {
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
        
        appleButton.rx.tap.subscribe(onNext: {
//            self.navigationController?.pushViewController(vc, animated: true)
            self.reactor.kakaoUnlink()
        }).disposed(by: disposeBag)
    }
    
    private func addSubView() {
        [imdangLogo, kakaoButton, kakaoLogo, googleButton, googleLogo, appleButton, appleLogo].forEach { view.addSubview($0) }
    }
    
    private func makeConstraints() {
        imdangLogo.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-50)
        }
        
        kakaoButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(googleButton.snp.top).offset(-12)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }
        kakaoLogo.snp.makeConstraints {
            $0.centerY.equalTo(kakaoButton.snp.centerY)
            $0.leading.equalTo(kakaoButton.snp.leading).offset(20)
        }
        
        googleButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(appleButton.snp.top).offset(-12)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }
        googleLogo.snp.makeConstraints {
            $0.centerY.equalTo(googleButton.snp.centerY)
            $0.leading.equalTo(googleButton.snp.leading).offset(20)
        }
        
        appleButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-40)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }
        appleLogo.snp.makeConstraints {
            $0.centerY.equalTo(appleButton.snp.centerY)
            $0.leading.equalTo(appleButton.snp.leading).offset(20)
        }
    }
    
    private func bind(reactor: SigninReactor) {
        kakaoButton.rx.tap
            .map { SigninReactor.Action.tapKakaoButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isKakaoSigninSuccess }
            .distinctUntilChanged()
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                let vc = OnboardingContainerViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }

}

