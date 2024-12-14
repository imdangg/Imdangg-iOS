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
    
    private let fullViewBotton = UIButton().then {
        $0.setTitle("전체보기", for: .normal)
        $0.titleLabel?.font = .pretenRegular(14)
        $0.setTitleColor(.white, for: .normal)
        
        var config = UIButton.Configuration.plain()
        config.titleAlignment = .center
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
        config.cornerStyle = .capsule
        config.background.backgroundColor = .mainOrange500
        config.background.strokeWidth = 1
        config.background.strokeColor = UIColor.grayScale100
        
        $0.configuration = config
    }
    
    private let kindViewButton = UIButton().then {
        $0.setTitle("단지별 보기", for: .normal)
        $0.titleLabel?.font = .pretenRegular(14)
        $0.setTitleColor(.grayScale700, for: .normal)
        
        var config = UIButton.Configuration.plain()
        config.titleAlignment = .center
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
        config.cornerStyle = .capsule
        config.background.strokeWidth = 1
        config.background.strokeColor = UIColor.grayScale100
        
        $0.configuration = config
    }
    
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
        }
        
        kindViewButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(fullViewBotton.snp.trailing).offset(8)
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
        fullViewBotton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.fullViewBotton.configuration?.background.backgroundColor = .mainOrange500
                self?.kindViewButton.configuration?.background.backgroundColor = .white
                
                self?.fullViewBotton.setTitleColor(.white, for: .normal)
                self?.kindViewButton.setTitleColor(.grayScale500, for: .normal)
            })
            .disposed(by: disposeBag)
        
        kindViewButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.fullViewBotton.configuration?.background.backgroundColor = .white
                self?.kindViewButton.configuration?.background.backgroundColor = .mainOrange500
                self?.kindViewButton.setTitle("ㅁㄴㅇㅁㄴㅇ ㅁㄴㅇ", for: .normal)
                
                self?.fullViewBotton.setTitleColor(.grayScale500, for: .normal)
                self?.kindViewButton.setTitleColor(.white, for: .normal)
            })
            .disposed(by: disposeBag)
    }
}
