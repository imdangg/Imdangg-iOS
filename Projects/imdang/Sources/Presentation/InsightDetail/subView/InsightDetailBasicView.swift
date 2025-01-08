//
//  InsightDetailBasicView.swift
//  SharedLibraries
//
//  Created by 임대진 on 1/8/25.
//

import UIKit
import Then
import SnapKit

class InsightDetailBasicView: UIView {
    private let mapButton = UIButton().then {
        $0.backgroundColor = .grayScale50
        
        $0.layer.cornerRadius = 16
    }
    
    private let adressTitleLabel = ImageTextLabel(horizonPadding: 0, spacing: 4).then {
        $0.customText.text = "단지 주소"
        $0.customText.textColor = .grayScale600
        $0.customText.font = .pretenMedium(14)
        
        $0.customImage.image = ImdangImages.Image(resource: .location)
        $0.customImage.tintColor = .grayScale600
        $0.imageSize = 16
    }
    private let adressLabel = UILabel().then {
        $0.font = .pretenMedium(16)
        $0.textColor = .grayScale900
        $0.numberOfLines = 0
    }
    
    private let dateTitleLabel = ImageTextLabel(horizonPadding: 0, spacing: 4).then {
        $0.customText.text = "임장 날짜 및 시간"
        $0.customText.textColor = .grayScale600
        $0.customText.font = .pretenMedium(14)
        
        $0.customImage.image = ImdangImages.Image(resource: .calendar)
        $0.customImage.tintColor = .grayScale600
        $0.imageSize = 16
    }
    
    private let dateLabel = UILabel().then {
        $0.font = .pretenMedium(16)
        $0.textColor = .grayScale900
    }
    
    private let transTitleLabel = ImageTextLabel(horizonPadding: 0, spacing: 4).then {
        $0.customText.text = "교통 수단"
        $0.customText.textColor = .grayScale600
        $0.customText.font = .pretenMedium(14)
        
        $0.customImage.image = ImdangImages.Image(resource: .car)
        $0.customImage.tintColor = .grayScale600
        $0.imageSize = 16
    }
    
    private let transLabel = UILabel().then {
        $0.font = .pretenMedium(16)
        $0.textColor = .grayScale900
    }
    
    private let accessTitleLabel = ImageTextLabel(horizonPadding: 0, spacing: 4).then {
        $0.customText.text = "출입 제한"
        $0.customText.textColor = .grayScale600
        $0.customText.font = .pretenMedium(14)
        
        $0.customImage.image = ImdangImages.Image(resource: .warning)
        $0.customImage.tintColor = .grayScale600
        $0.imageSize = 16
    }
    
    private let accessLabel = UILabel().then {
        $0.font = .pretenMedium(16)
        $0.textColor = .grayScale900
    }
    
    private let summaryTitleLabel = UILabel().then {
        $0.text = "인사이트 요약"
        $0.font = .pretenMedium(14)
        $0.textColor = .grayScale600
    }
    
    private let summaryLabel = UILabel().then {
        $0.font = .pretenMedium(16)
        $0.textColor = .grayScale900
        $0.numberOfLines = 0
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
        [adressTitleLabel, adressLabel, mapButton, dateTitleLabel, dateLabel, transTitleLabel, transLabel, accessTitleLabel, accessLabel, summaryTitleLabel, summaryLabel].forEach { addSubview($0) }
    }
    
    private func makeConstraints() {
        adressTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(20)
        }
        adressLabel.snp.makeConstraints {
            $0.top.equalTo(adressTitleLabel.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        mapButton.snp.makeConstraints {
            $0.top.equalTo(adressLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(200)
        }
        
        dateTitleLabel.snp.makeConstraints {
            $0.top.equalTo(mapButton.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(20)
        }
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(dateTitleLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(20)
        }
        
        transTitleLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(20)
        }
        transLabel.snp.makeConstraints {
            $0.top.equalTo(transTitleLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(20)
        }
        
        accessTitleLabel.snp.makeConstraints {
            $0.top.equalTo(transLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(20)
        }
        accessLabel.snp.makeConstraints {
            $0.top.equalTo(accessTitleLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(20)
        }
        
        summaryTitleLabel.snp.makeConstraints {
            $0.top.equalTo(accessLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(20)
        }
        summaryLabel.snp.makeConstraints {
            $0.top.equalTo(summaryTitleLabel.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    func config(info: InsightDetail) {
        adressLabel.text = info.basicInfo.adress
        dateLabel.text = info.basicInfo.writeDate
        transLabel.text = info.basicInfo.transportation
        accessLabel.text = info.basicInfo.restrictionsOnAccess
        summaryLabel.setTextWithLineHeight(text: info.basicInfo.summary, lineHeight: 22.4)
    }
}
