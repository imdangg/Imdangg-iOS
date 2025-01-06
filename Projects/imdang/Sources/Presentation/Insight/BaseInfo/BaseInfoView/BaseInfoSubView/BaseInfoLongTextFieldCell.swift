//
//  LoingTextFieldCell.swift
//  imdang
//
//  Created by daye on 12/29/24.
//

import UIKit
import RxSwift
import RxRelay

class BaseInfoLongTextFieldCell: UICollectionViewCell {
    
    static let identifier = "LongTextFieldCell"
    let disposeBag = DisposeBag()
    
    let buttonTapState = PublishRelay<Void>()
    
    private let buttonView = CommonButton(title: "예시)\n지하철역과 도보 10분 거리로 접근성이 좋지만, 근처 공사로 소음 문제가 있을 수 있을 것 같아요. 하지만 단지 내 공원이 잘 조성되어 있어 가족 단위 거주자에게 적합할 것 같아요"
                                          ,initialButtonType: .unselectedBorderStyle
                                          ,radius: 8).then {
        $0.titleLabel?.numberOfLines = 0
        $0.titleLabel?.textAlignment = .left
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(buttonView)
        buttonView.snp.makeConstraints {
            $0.height.equalTo(180)
            $0.horizontalEdges.equalToSuperview()
        }
        bind()
    }
    
    func bind() {
        buttonView.rx.tap
            .bind(to: buttonTapState)
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String) {
       
    }
}

