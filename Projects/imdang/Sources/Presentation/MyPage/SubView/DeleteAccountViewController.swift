//
//  DeleteAccountViewController.swift
//  imdang
//
//  Created by daye on 1/15/25.
//


import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

final class DeleteAccountViewController: BaseViewController {
    
    private let disposeBag = DisposeBag()
    private var onTabCheckButton = false

    private let noticeScripts = [
        "1. 탈퇴한 계정의 이용 내역, 쿠폰, 혜택은 복구되지 않습니다.",
        "2. 작성하신 인사이트 및 댓글은 삭제되지 않습니다. 삭제 희망시 탈퇴 전 고객센터로 요청해 주시길 바랍니다.",
        "3. 탈퇴 시, 고객님의 정보는 소비자 보호에 관한 법률에 의거한 고객 정보 보호 정책에 따라 관리됩니다."
    ]
    
    private let noticeTitleLabel = UILabel().then {
        $0.text = "회원 탈퇴 안내"
        $0.font = .pretenSemiBold(18)
        $0.textColor = .grayScale900
    }
    
    private let noticeStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 18
        $0.alignment = .leading
    }
    
    private let agreeButton = CheckButton()
    private let deleteButton = CommonButton(title: "탈퇴하기", initialButtonType: .unselectedBorderStyle).then {
        $0.isEnabled = false
    }
    
    private let navigationTitleLabel = UILabel().then {
        $0.text = "계정 탈퇴"
        $0.font = .pretenSemiBold(18)
        $0.textColor = .grayScale900
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        setupUI()
        bindUI()
    }
    
    private func addSubViews() {
        [noticeTitleLabel, noticeStackView, agreeButton, deleteButton].forEach {view.addSubview($0)}
    }
    
    private func setupUI() {
        
        agreeButton.configure(isBackground: true, title: "유의사항을 모두 확인했으며, 이에 동의합니다.")
        configNavigationBarItem()
        noticeScripts.forEach { script in
            let label = UILabel().then {
                $0.text = script
                $0.font = .pretenMedium(14)
                $0.textColor = .grayScale700
                $0.numberOfLines = 0
            }
            noticeStackView.addArrangedSubview(label)
        }
        
        noticeTitleLabel.snp.makeConstraints {
            $0.topEqualToNavigationBottom(vc: self).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        noticeStackView.snp.makeConstraints {
            $0.top.equalTo(noticeTitleLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        agreeButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }
        
        deleteButton.snp.makeConstraints {
            $0.top.equalTo(agreeButton.snp.bottom).offset(24)
            $0.bottom.equalToSuperview().inset(40)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }
    }
    
    private func bindUI() {
        agreeButton.rx.tap
            .subscribe(onNext: {
                self.onTabCheckButton.toggle()
                self.agreeButton.setState(isSelected: self.onTabCheckButton)
                
                print(self.onTabCheckButton)
                self.deleteButton.isEnabled.toggle()
                self.deleteButton.setButtonTitleColor(color: self.deleteButton.isEnabled ? .grayScale700 : .grayScale400 )
            })
            .disposed(by: disposeBag)
 
        deleteButton.rx.tap
            .subscribe(onNext: {
                print("탈퇴 완료")
                
                let vc = CommonAlertViewController()
                vc.configure(script: "정상적으로 로그아웃 되었어요.", confirmString: "로그아웃")
                vc.hidesBottomBarWhenPushed = false
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: false)
                
                vc.confirmAction = {
                    vc.dismiss(animated: true)
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootView(SigninViewController(), animated: true)
                }
                vc.cancelAction = {
                    print("취소핑")
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func configNavigationBarItem() {
        customBackButton.isHidden = false
        
        leftNaviItemView.addSubview(navigationTitleLabel)
        navigationTitleLabel.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
        }
    }
}
