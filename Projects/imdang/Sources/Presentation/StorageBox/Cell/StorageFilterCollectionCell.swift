//
//  StorageFilterCollectionCell.swift
//  imdang
//
//  Created by 임대진 on 2/7/25.
//

import Foundation

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class StorageFilterCollectionCell: UICollectionViewCell {
    
    weak var delegate: ReusableViewDelegate?
    
    private var disposeBag = DisposeBag()
    
    let viewAllButton = UIButton().then {
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


    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview()
        makeConstraints()
        bindActions()
    }
    
    override func prepareForReuse() {
        viewAllButton.setTitleColor(.white, for: .normal)
        viewAllButton.backgroundColor = .mainOrange500
        viewAllButton.layer.borderWidth = 0
        
        areaSeletButton.customText.textColor = .grayScale500
        areaSeletButton.customImage.tintColor = .grayScale500
        areaSeletButton.backgroundColor = .white
        areaSeletButton.layer.borderWidth = 1
        areaSeletButton.customText.text = "단지별 보기"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubview() {
        [viewAllButton, areaSeletButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func makeConstraints() {
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
                areaSeletButton.customText.text = "단지별 보기"
            })
            .disposed(by: disposeBag)

        areaSeletButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                delegate?.didTapAreaSeletButton()
            })
            .disposed(by: disposeBag)
    }
    
    func config() {
        viewAllButton.setTitleColor(.white, for: .normal)
        viewAllButton.backgroundColor = .mainOrange500
        viewAllButton.layer.borderWidth = 0
        
        areaSeletButton.customText.textColor = .grayScale500
        areaSeletButton.customImage.tintColor = .grayScale500
        areaSeletButton.backgroundColor = .white
        areaSeletButton.layer.borderWidth = 1
        areaSeletButton.customText.text = "단지별 보기"
    }
    
    func updateLabel(complex: String) {
        
        viewAllButton.setTitleColor(.grayScale500, for: .normal)
        viewAllButton.backgroundColor = .white
        viewAllButton.layer.borderWidth = 1
        
        areaSeletButton.customText.text = complex
        areaSeletButton.customText.textColor = .white
        areaSeletButton.customImage.tintColor = .white
        areaSeletButton.backgroundColor = .mainOrange500
        areaSeletButton.layer.borderWidth = 0
    }
}
