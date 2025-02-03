//
//  InsightHeaderView.swift
//  imdang
//
//  Created by 임대진 on 12/15/24.
//

import UIKit
import Then
import RxSwift
import RxCocoa

protocol ReusableViewDelegate: AnyObject {
    func didTapFullViewButton()
    func didTapAreaSeletButton()
    func disTapSortButton(isOn: Bool)
}

class InsightHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "InsightHeaderView"
    weak var delegate: ReusableViewDelegate?
    private let disposeBag = DisposeBag()
    
    private let viewAllButton = UIButton().then {
        $0.setTitle("전체", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .pretenSemiBold(14)
        $0.backgroundColor = .mainOrange500
        
        $0.layer.borderWidth = 0
        $0.layer.borderColor = UIColor.grayScale100.cgColor
        $0.layer.cornerRadius = 18
    }
    
    private let areaSeletButton = ImageTextButton(type: .textFirst, horizonPadding: 16, spacing: 8).then {
        $0.customText.text = "단지별 보기"
        $0.customText.font = .pretenSemiBold(14)
        $0.customText.textColor = .grayScale500
        
        $0.customImage.image = ImdangImages.Image(resource: .chevronDown).withRenderingMode(.alwaysTemplate)
        $0.imageSize = 12
        $0.customImage.tintColor = .grayScale500
        
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.grayScale100.cgColor
        $0.layer.cornerRadius = 18
    }
    
    private let myInsightLabel = UILabel().then {
        $0.text = "내 인사이트만 보기"
        $0.textColor = .grayScale700
        $0.font = .pretenMedium(14)
    }
    
    private let insightCount = UILabel().then {
        $0.textColor = .grayScale900
        $0.font = .pretenSemiBold(16)
    }
    
    private var toggleSwitch = CustomSwitch()
    
    private let secondLineView = UIView().then {
        $0.backgroundColor = .white
        
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.grayScale100.cgColor
    }
    
    private let firstLineView = UIView().then {
        $0.backgroundColor = .white
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        addSubViews()
        makeConstraints()
        bindActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubViews() {
        [viewAllButton, areaSeletButton].forEach {
            firstLineView.addSubview($0)
        }
        [myInsightLabel, toggleSwitch, insightCount].forEach {
            secondLineView.addSubview($0)
        }
        [firstLineView, secondLineView].forEach {
            addSubview($0)
        }
    }
    
    private func makeConstraints() {
        firstLineView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(68)
        }
        
        secondLineView.snp.makeConstraints {
            $0.top.equalTo(firstLineView.snp.bottom)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(54)
        }
        
        viewAllButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.width.equalTo(57)
            $0.height.equalTo(36)
        }
        
        areaSeletButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(viewAllButton.snp.trailing).offset(8)
            $0.height.equalTo(36)
        }
        
        myInsightLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
        
        toggleSwitch.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(myInsightLabel.snp.trailing).offset(8)
            $0.width.equalTo(32)
            $0.height.equalTo(18)
        }
        
        insightCount.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-20)
        }
    }
    
    func bindActions() {
        viewAllButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                viewAllButton.setTitleColor(.white, for: .normal)
                viewAllButton.backgroundColor = .mainOrange500
                viewAllButton.layer.borderWidth = 0
                
                areaSeletButton.customText.textColor = .grayScale500
                areaSeletButton.customImage.tintColor = .grayScale500
                areaSeletButton.backgroundColor = .white
                areaSeletButton.layer.borderWidth = 1
            })
            .disposed(by: disposeBag)

        areaSeletButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                viewAllButton.setTitleColor(.grayScale500, for: .normal)
                viewAllButton.backgroundColor = .white
                viewAllButton.layer.borderWidth = 1
                
                areaSeletButton.customText.textColor = .white
                areaSeletButton.customImage.tintColor = .white
                areaSeletButton.backgroundColor = .mainOrange500
                areaSeletButton.layer.borderWidth = 0
                
                delegate?.didTapAreaSeletButton()
            })
            .disposed(by: disposeBag)
        
        toggleSwitch.valueChanged = { [self] in
            delegate?.disTapSortButton(isOn: $0)
        }
    }
    
    func config(insightCount: Int, toggleState: Bool) {
        self.insightCount.text = "\(insightCount)개"
        self.toggleSwitch.setOn(toggleState)
    }

}
