//
//  NotificationTypeHeaderView.swift
//  segmentedControl
//
//  Created by markany on 1/20/25.
//


import UIKit
import RxSwift
import Then
import SnapKit
import ReactorKit


//enum NotificationType: String, Equatable {
//    case all = "전체"
//    case request = "내가 요청한 내역"
//    case response = "요청 받은 내역"
//}

final class NotificationTypeHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "NotificationTypeHeaderView"

    private let notificationTypeView = NotificationTypeButtonView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(notificationTypeView)
        notificationTypeView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class NotificationTypeButtonView: UIView {
    var allButton = CommonButton(title: NotificationType.all.rawValue, initialButtonType: .unselectedBorderStyle, radius: 18)
    var requestButton = CommonButton(title: NotificationType.request.rawValue, initialButtonType: .unselectedBorderStyle, radius: 18)
    var responseButton = CommonButton(title: NotificationType.response.rawValue, initialButtonType: .unselectedBorderStyle, radius: 18)
    
    lazy var views = UIView().then  {
        $0.addSubview(allButton)
        $0.addSubview(requestButton)
        $0.addSubview(responseButton)
    }
    
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(views)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        views.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().inset(20)
        }
        
        allButton.snp.makeConstraints {
            $0.verticalEdges.equalTo(views.snp.verticalEdges)
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
    
//    func bind(reactor: NotificationReactor) {
//           // 버튼 탭 액션을 Reactor에 바인딩
//           allButton.rx.tap
//               .map { NotificationReactor.Action.tapNotificationTypeButton(.all) }
//               .bind(to: reactor.action)
//               .disposed(by: disposeBag)
//
//           requestButton.rx.tap
//               .map { NotificationReactor.Action.tapNotificationTypeButton(.request) }
//               .bind(to: reactor.action)
//               .disposed(by: disposeBag)
//
//           responseButton.rx.tap
//               .map { NotificationReactor.Action.tapNotificationTypeButton(.response) }
//               .bind(to: reactor.action)
//               .disposed(by: disposeBag)
//
//           // 상태 변경에 따른 버튼 스타일 업데이트
//           reactor.state
//               .map { $0.selectedNotificationType }
//               .distinctUntilChanged()
//               .subscribe(onNext: { [weak self] selectedType in
//                   guard let self = self else { return }
//
//                   self.allButton.rx.commonButtonState.onNext(
//                       selectedType == .all ? .enabled : .unselectedBorderStyle
//                   )
//                   self.requestButton.rx.commonButtonState.onNext(
//                       selectedType == .request ? .enabled : .unselectedBorderStyle
//                   )
//                   self.responseButton.rx.commonButtonState.onNext(
//                       selectedType == .response ? .enabled : .unselectedBorderStyle
//                   )
//               })
//               .disposed(by: disposeBag)
//       }
}

