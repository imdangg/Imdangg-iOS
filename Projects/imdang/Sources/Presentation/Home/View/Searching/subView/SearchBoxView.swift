//
//  SearchBoxView.swift
//  imdang
//
//  Created by 임대진 on 12/4/24.
//

import UIKit
import SnapKit

class SearchBoxView: UIView {
    let searchButton = ImageTextButton(type: .imageFirst, horizonPadding: 12, spacing: 8).then {
        $0.customImage.image = ImdangImages.Image(resource: .magnifier)
        $0.imageSize = 16
        $0.customText.text = "어떤 지역의 인사이트를 찾으시나요?"
        $0.customText.font = .pretenMedium(14)
        $0.customText.textColor = .grayScale500
        
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.grayScale100.cgColor
    }
    
    let mapButton = UIButton().then {
        $0.setImage(ImdangImages.Image(resource: .mapButton), for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeConstraints()
    }
    
    private func makeConstraints() {
        self.addSubview(searchButton)
        self.addSubview(mapButton)
        
        searchButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalTo(mapButton.snp.leading).offset(-8)
            $0.height.equalTo(50)
        }
        
        mapButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-20)
            $0.width.height.equalTo(50)
        }
    }
}

