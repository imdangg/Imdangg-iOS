//
//  InsightDetailTitleView.swift
//  SharedLibraries
//
//  Created by 임대진 on 1/8/25.
//

import UIKit
import Then
import SnapKit

class InsightDetailTitleView: UIView {
    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = ImdangImages.Image(resource: .person)
        $0.layer.cornerRadius = 32 / 2
        $0.clipsToBounds = true
    }
    
    private let userNameLabel = UILabel().then {
        $0.font = .pretenMedium(16)
        $0.textColor = .grayScale700
    }
    
    private let likeLabel = ImageTextButton(type: .imageFirst, horizonPadding: 12, spacing: 2).then {
        $0.customText.text = "추천 0"
        $0.customText.textColor = .grayScale700
        $0.customText.font = .pretenMedium(14)
        
        $0.customImage.image = ImdangImages.Image(resource: .good)
        $0.customImage.tintColor = .grayScale700
        $0.imageSize = 16
        
        $0.layer.borderColor = UIColor.grayScale100.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 4
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .pretenBold(22)
        $0.textColor = .grayScale900
    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        [profileImageView, userNameLabel, likeLabel, titleLabel].forEach { addSubview($0) }
    }
    
    private func makeConstraints() {
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(26)
            $0.leading.equalToSuperview().offset(20)
            $0.width.height.equalTo(32)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView.snp.centerY)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(4)
        }
        
        likeLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView.snp.centerY)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(36)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
        }
    }
    
    func config(info: InsightDetail) {
        profileImageView.image = info.profileImage
        userNameLabel.text = info.userName
        likeLabel.customText.text = "추천 \(info.likeCount)"
        titleLabel.text = info.titleName
    }
}
