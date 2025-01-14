//
//  ImageTextLabel.swift
//  imdang
//
//  Created by 임대진 on 1/8/25.
//

import UIKit
import Then
import SnapKit

class ImageTextLabel: UILabel {
    let customImage = UIImageView()
    let customText = UILabel()
    /// 왼쪽에 먼저오는 아이템
    let type: PriorityType
    /// 왼쪽 아이템 끝부터 이미지까지 간격
    var horizonPadding: Int
    /// 왼쪽 아이템 끝부터 텍스트까지 간격
    var spacing: Int
    var imageSize: Int? {
        didSet {
            customImage.snp.makeConstraints {
                $0.width.height.equalTo(imageSize ?? 0)
            }
        }
    }

    init(frame: CGRect = .zero, type: PriorityType = .imageFirst, horizonPadding: Int, spacing: Int) {
        self.type = type
        self.horizonPadding = horizonPadding
        self.spacing = spacing
        super.init(frame: frame)
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        self.addSubview(customImage)
        self.addSubview(customText)
    }
    
    func makeConstraints() {
        if type == .imageFirst {
            customImage.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview().offset(horizonPadding)
            }
            
            customText.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalTo(customImage.snp.trailing).offset(spacing)
                $0.trailing.equalToSuperview().offset(-horizonPadding)
            }
        } else {
            customText.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview().offset(horizonPadding)
            }
            
            customImage.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalTo(customText.snp.trailing).offset(spacing)
                $0.trailing.equalToSuperview().offset(-horizonPadding)
            }
        }
    }
    
    func updateConstraint() {
        self.snp.updateConstraints { make in
            let totalWidth = calculateTotalWidth()
            make.width.equalTo(totalWidth)
        }
    }
    
    private func calculateTotalWidth() -> CGFloat {
        let textWidth = customText.intrinsicContentSize.width
        let imageWidth = CGFloat(imageSize ?? 0)
        return CGFloat(horizonPadding * 2) + imageWidth + CGFloat(spacing) + textWidth
    }
}
