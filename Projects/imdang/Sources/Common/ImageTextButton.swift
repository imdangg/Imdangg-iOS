//
//  ImageTextButton.swift
//  imdang
//
//  Created by 임대진 on 12/16/24.
//

import UIKit
import Then
import SnapKit

class ImageTextButton: UIButton {
    let iconImageView = UIImageView()
    let textLabel = UILabel()
    var imagePadding: Int
    var textPadding: Int

    init(frame: CGRect = .zero, imagePadding: Int, textPadding: Int) {
        self.imagePadding = imagePadding
        self.textPadding = textPadding
        super.init(frame: frame)
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        self.addSubview(iconImageView)
        self.addSubview(textLabel)
    }
    
    func makeConstraints() {
        iconImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(imagePadding)
        }
        
        textLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(iconImageView.snp.trailing).offset(textPadding)
        }
    }
}
