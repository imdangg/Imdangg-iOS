//
//  NoticeCell.swift
//  imdang
//
//  Created by daye on 12/4/24.
//

import UIKit

final class NoticeScriptView: UIView {
    
    private let iconImageView = UIImageView().then {
        $0.image = UIImage(systemName: "exclamationmark.circle")
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .grayScale600
    }
    
    private let textLabel = UILabel().then {
        $0.text = ""
        $0.textColor = .black
        $0.font = .pretenMedium(14)
        $0.textColor = .grayScale600
        $0.numberOfLines = 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = .grayScale50
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
       
        addSubview(iconImageView)
        addSubview(textLabel)
        
        iconImageView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 16, height: 18))
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(16)
        }
        
        textLabel.snp.makeConstraints {
            $0.leading.equalTo(iconImageView.snp.trailing).offset(4)
            $0.top.bottom.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    // 변경 사용해야돼서 메소드로 선언
    func configure(text: String) {
        textLabel.text = text
    }
}
