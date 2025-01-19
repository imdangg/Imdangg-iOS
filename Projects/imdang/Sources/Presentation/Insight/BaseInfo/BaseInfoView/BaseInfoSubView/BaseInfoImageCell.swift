//
//  ImageCell.swift
//  imdang
//
//  Created by daye on 12/23/24.
//

import UIKit
import SnapKit
import RxSwift
import ReactorKit
import RxRelay

class BaseInfoImageCell: UICollectionViewCell {
    static let identifier = "ImageCell"
    
    let disposeBag = DisposeBag()
    let buttonTapState = PublishRelay<Void>()
    
    private let imageButton = UIButton(type: .custom).then {
        $0.contentMode = .scaleAspectFit
        $0.setImage(UIImage(resource: .photo), for: .normal)
        $0.clipsToBounds = true
        $0.backgroundColor = .grayScale50
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 4
        $0.layer.borderColor = UIColor.grayScale100.cgColor
    }
    
    private let addButton = ImageTextButton(type: .imageFirst, horizonPadding: 12, spacing: 3).then {
        $0.customText.text = "이미지 추가"
        $0.customText.textColor = .grayScale700
        $0.customText.font = .pretenBold(12)
        $0.customImage.image = ImdangImages.Image(systemName: "plus")
        $0.customImage.tintColor = .grayScale700
        $0.imageSize = 12
        
        $0.layer.cornerRadius = 6
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.grayScale100.cgColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .grayScale25
        layout()
        imageButtonTapState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        contentView.addSubview(imageButton)
        contentView.addSubview(addButton)
        
        imageButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.width.equalTo(140)
            $0.height.equalTo(100)
        }
        
        addButton.snp.makeConstraints {
            $0.leading.equalTo(imageButton.snp.trailing).offset(20)
            $0.centerY.equalToSuperview()
        }
    }
    
    func resultImageAccept(image: UIImage) {
        self.imageButton.setImage(image, for: .normal)
    }
    
    func imageButtonTapState() {
        imageButton.rx.tap
            .bind(to: buttonTapState)
            .disposed(by: disposeBag)
        
        addButton.rx.tap
            .bind(to: buttonTapState)
            .disposed(by: disposeBag)
    }
}
