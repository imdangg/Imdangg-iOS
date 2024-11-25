//
//  InsightCollectionCell.swift
//  SharedLibraries
//
//  Created by 임대진 on 11/26/24.
//

import UIKit
import Kingfisher

final class InsightCollectionCell: UICollectionViewCell {
    
    private let titleImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 4
        $0.clipsToBounds = true
    }
    
    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = ImdangImages.Image(resource: .person)
        $0.clipsToBounds = true
    }
    
    // 라밸 패딩이 adressLabel는 이미지 들어가서 상하 기준이 안맞음.. 피그마로 비교해서 맞춰놨어여
    private let adressLabel = PaddingLabel().then {
        $0.textAlignment = .center
        $0.backgroundColor = .grayScale50
        $0.layer.cornerRadius = 2
        $0.clipsToBounds = true
        $0.padding = UIEdgeInsets(top: 2.5, left: 8, bottom: 2.5, right: 8)
    }
    
    private let likeLabel = PaddingLabel().then {
        $0.textAlignment = .center
        $0.backgroundColor = .mainOrange50
        $0.layer.cornerRadius = 2
        $0.textColor = .mainOrange500
        $0.font = UIFont.pretenMedium(12)
        $0.clipsToBounds = true
    }
    
    private let titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .grayScale900
        $0.font = UIFont.pretenMedium(16)
    }
    
    private let userNameLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .grayScale700
        $0.font = UIFont.pretenMedium(14)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubView()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        titleImageView.image = UIImage(systemName: "")
        profileImageView.image = UIImage(systemName: "")
        
        adressLabel.text = ""
        likeLabel.text = ""
        titleLabel.text = ""
        userNameLabel.text = ""
    }
    
    private func addSubView() {
        [titleImageView, profileImageView, adressLabel, likeLabel, titleLabel, userNameLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func makeConstraints() {
        titleImageView.snp.makeConstraints {
            $0.width.height.equalTo(100)
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        adressLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(2.5)
            $0.leading.equalTo(titleImageView.snp.trailing).offset(16)
        }
        
        likeLabel.snp.makeConstraints {
            $0.top.equalTo(adressLabel.snp.top)
            $0.leading.equalTo(adressLabel.snp.trailing).offset(4)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(adressLabel.snp.bottom).offset(12)
            $0.leading.equalTo(adressLabel.snp.leading)
        }
        
        profileImageView.snp.makeConstraints {
            $0.width.height.equalTo(22)
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.equalTo(adressLabel.snp.leading)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(4)
        }
    }
    
    private func createAttributedString(image: UIImage, text: String) -> NSAttributedString {
        let attachment = NSTextAttachment()
        attachment.image = image.withRenderingMode(.alwaysOriginal)
        attachment.bounds = CGRect(x: 0, y: 0, width: 12, height: 12)
        
        let imageString = NSAttributedString(attachment: attachment)
        let textString = NSAttributedString(string: " \(text)", attributes: [
            .font: UIFont.pretenMedium(12),
            .foregroundColor: UIColor.grayScale700,
            .baselineOffset: 2
        ])
        
        let combined = NSMutableAttributedString()
        combined.append(imageString)
        combined.append(textString)
        
        return combined
    }
    
    func configure(insight: Insight) {
        guard let url = URL(string: insight.titleImageUrl) else { return }
        titleImageView.kf.setImage(with: url)
        titleImageView.contentMode = .scaleAspectFill
        profileImageView.image = ImdangImages.Image(resource: .person)
        
        adressLabel.attributedText = createAttributedString(image: ImdangImages.Image(resource: .location), text: insight.adress)
        likeLabel.text = "추천 \(insight.likeCount)"
        titleLabel.text = insight.titleName
        userNameLabel.text = insight.userName
    }
}

