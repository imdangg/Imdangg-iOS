//
//  LocationBoxHeaderCell.swift
//  SharedLibraries
//
//  Created by 임대진 on 12/9/24.
//

import UIKit
import Then
import RxSwift
import RxCocoa

class LocationBoxHeaderCell: UICollectionReusableView {
    static let reuseIdentifier = "LocationBoxHeaderCell"
    private let disposeBag = DisposeBag()
    
    private let isClicked: UIButton.Configuration = {
        var config = UIButton.Configuration.plain()
        config.title = "전체"
        config.attributedTitle?.font = .pretenSemiBold(14)
        config.baseForegroundColor = .white
        config.titleAlignment = .center
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
        config.cornerStyle = .capsule
        config.background.backgroundColor = .mainOrange500
        config.background.strokeWidth = 0
        config.background.strokeColor = UIColor.grayScale100
        return config
    }()
    
    private let isNoClicked: UIButton.Configuration = {
        var config = UIButton.Configuration.plain()
        config.title = "전체"
        config.attributedTitle?.font = .pretenSemiBold(14)
        config.baseForegroundColor = .grayScale500
        config.titleAlignment = .center
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
        config.cornerStyle = .capsule
        config.background.backgroundColor = .white
        config.background.strokeWidth = 1
        config.background.strokeColor = UIColor.grayScale100
        return config
    }()
    
    private let fullViewBotton = UIButton()
    
    private let kindViewButton = UIButton()
    
    private let myInsightLabel = UILabel().then {
        $0.text = "내 인사이트만 보기"
        $0.textColor = .grayScale700
        $0.font = .pretenMedium(14)
    }
    
    private let insightCount = UILabel().then {
        $0.text = "33개"
        $0.textColor = .grayScale900
        $0.font = .pretenSemiBold(16)
    }
    
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
        setUpButtons()
        bindActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubViews() {
        [fullViewBotton, kindViewButton].forEach {
            firstLineView.addSubview($0)
        }
        [myInsightLabel, insightCount].forEach {
            secondLineView.addSubview($0)
        }
        [firstLineView, secondLineView].forEach {
            addSubview($0)
        }
    }
    private func setUpButtons() {
        var click = isClicked
        var noClick = isNoClicked
        
        click.title = "전체"
        click.attributedTitle?.font = .pretenSemiBold(14)
        fullViewBotton.configuration = click
        
        noClick.title = "신논현 더 센트럴 푸르지오"
        noClick.attributedTitle?.font = .pretenSemiBold(14)
        kindViewButton.configuration = noClick
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
        
        fullViewBotton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(36)
        }
        
        kindViewButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(fullViewBotton.snp.trailing).offset(8)
            $0.height.equalTo(36)
        }
        
        myInsightLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
        
        insightCount.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-20)
        }
    }
    
    func bindActions() {
        var click = isClicked
        var noClick = isNoClicked
        
        
        fullViewBotton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                click.title = "전체"
                noClick.title = "신논현 더 센트럴 푸르지오"
                click.attributedTitle?.font = .pretenSemiBold(14)
                noClick.attributedTitle?.font = .pretenSemiBold(14)
                self?.fullViewBotton.configuration = click
                self?.kindViewButton.configuration = noClick
            })
            .disposed(by: disposeBag)

        kindViewButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                click.title = "신논현 더 센트럴 푸르지오"
                noClick.title = "전체"
                click.attributedTitle?.font = .pretenSemiBold(14)
                noClick.attributedTitle?.font = .pretenSemiBold(14)
                self?.fullViewBotton.configuration = noClick
                self?.kindViewButton.configuration = click
            })
            .disposed(by: disposeBag)
    }

}
