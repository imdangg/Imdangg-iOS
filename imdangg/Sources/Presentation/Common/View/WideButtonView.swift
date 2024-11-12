//
//  WideButtonView.swift
//  imdangg
//
//  Created by daye on 11/11/24.
//
import UIKit
import RxSwift
import RxCocoa

// TODO: 미완성
class WideButtonView: UIView {
    
    private let disposeBag = DisposeBag()
    private let wideButton = UIButton()
    
    let isEnabled = BehaviorRelay(value: false)
    let buttonTitle = BehaviorRelay(value: "완료")
    let submit = BehaviorRelay(value: false)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
        makeUI()
        bindButtonProperties()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupButton() {
        wideButton.setTitleColor(.white, for: .normal)
        wideButton.titleLabel?.font = FontUtility.getFont(type: .semiBold, size: 16)
        wideButton.layer.cornerRadius = 8
        wideButton.clipsToBounds = true
        addSubview(wideButton)
    }
    
    private func makeUI() {
        wideButton.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    private func bindButtonProperties() {
        isEnabled
            .withUnretained(wideButton)
            .subscribe(onNext: { button, enabled in
                button.backgroundColor = enabled ? .mainOrange500 : .grayScale100
                button.setTitleColor(enabled ? .white : .grayScale500, for: .normal)
            })
            .disposed(by: disposeBag)
        wideButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.isEnabled.accept(!(self?.isEnabled.value ?? false))
            })
            .disposed(by: disposeBag)
        
        buttonTitle
            .bind(to: wideButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
    }
    
    func observeSubmitState() -> Observable<Bool> {
        return submit.asObservable()
    }
    
    func observeisEnabledState() -> Observable<Bool> {
        return isEnabled.asObservable()
    }
}
