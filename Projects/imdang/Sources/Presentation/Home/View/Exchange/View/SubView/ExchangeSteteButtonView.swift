//
//  Exchange.swift
//  imdang
//
//  Created by daye on 12/4/24.
//
import UIKit
import RxSwift
import Then
import SnapKit
import ReactorKit

enum ExchangeState: String, Equatable {
    case waiting = "대기 중"
    case reject = "거절"
    case done = "교환 완료"
}

class ExchangeStateButtonView: UIView {
    // Buttons
    var waitingButton = CommonButton(title: ExchangeState.waiting.rawValue, initialButtonType: .unselectedBorderStyle, radius: 18)
    var rejectButton = CommonButton(title: ExchangeState.reject.rawValue, initialButtonType: .unselectedBorderStyle, radius: 18)
    var doneButton = CommonButton(title: ExchangeState.done.rawValue, initialButtonType: .unselectedBorderStyle, radius: 18)
    
    lazy var views = UIView().then  {
        $0.addSubview(waitingButton)
        $0.addSubview(rejectButton)
        $0.addSubview(doneButton)
    }
    
    // Dispose bag
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
            $0.edges.equalToSuperview()
        }
        
        waitingButton.snp.makeConstraints {
            $0.verticalEdges.equalTo(views.snp.verticalEdges)
            $0.height.equalTo(36)
        }
        
        rejectButton.snp.makeConstraints {
            $0.top.equalTo(waitingButton)
            $0.leading.equalTo(waitingButton.snp.trailing).offset(8)
            $0.height.equalTo(waitingButton)
        }
        
        doneButton.snp.makeConstraints {
            $0.top.equalTo(waitingButton)
            $0.leading.equalTo(rejectButton.snp.trailing).offset(8)
            $0.height.equalTo(waitingButton)
        }
    }
}
