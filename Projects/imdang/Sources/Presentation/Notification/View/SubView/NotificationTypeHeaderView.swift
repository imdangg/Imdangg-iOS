//
//  NotificationTypeHeaderView.swift
//  imdang
//
//  Created by daye on 1/20/25.
//


import UIKit
import RxSwift
import Then
import SnapKit
import ReactorKit

final class NotificationTypeHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "NotificationTypeHeaderView"
    
    var allButton = CommonButton(title: NotificationType.all.rawValue, initialButtonType: .unselectedBorderStyle, radius: 18)
    var requestButton = CommonButton(title: NotificationType.request.rawValue, initialButtonType: .unselectedBorderStyle, radius: 18)
    var responseButton = CommonButton(title: NotificationType.response.rawValue, initialButtonType: .unselectedBorderStyle, radius: 18)
    
    let tapSubject = PublishSubject<NotificationType>()
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [allButton, requestButton, responseButton].forEach {addSubview($0)}
    }
    
    private func setupConstraints() {
        allButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.verticalEdges.equalToSuperview().inset(12)
            $0.height.equalTo(36)
        }
        
        requestButton.snp.makeConstraints {
            $0.top.equalTo(allButton)
            $0.leading.equalTo(allButton.snp.trailing).offset(8)
            $0.height.equalTo(allButton)
        }
        
        responseButton.snp.makeConstraints {
            $0.top.equalTo(allButton)
            $0.leading.equalTo(requestButton.snp.trailing).offset(8)
            $0.height.equalTo(allButton)
        }
    }
    
    private func bind() {
        allButton.rx.tap
            .map { NotificationType.all }
            .bind(to: tapSubject)
            .disposed(by: disposeBag)
        
        requestButton.rx.tap
            .map { NotificationType.request }
            .bind(to: tapSubject)
            .disposed(by: disposeBag)
        
        responseButton.rx.tap
            .map { NotificationType.response }
            .bind(to: tapSubject)
            .disposed(by: disposeBag)
    }
    
    func bind(reactor: NotificationReactor) {
        tapSubject
            .map { NotificationReactor.Action.tapNotificationTypeButton($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.selectedNotificationType }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] selectedType in
                guard let self = self else { return }
                
                self.allButton.rx.commonButtonState.onNext(
                    selectedType == .all ? .enabled : .unselectedBorderStyle
                )
                self.requestButton.rx.commonButtonState.onNext(
                    selectedType == .request ? .enabled : .unselectedBorderStyle
                )
                self.responseButton.rx.commonButtonState.onNext(
                    selectedType == .response ? .enabled : .unselectedBorderStyle
                )
            })
            .disposed(by: disposeBag)
    }
}
