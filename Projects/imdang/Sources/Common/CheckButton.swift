//
//  CommonCheckButton.swift
//  imdang
//
//  Created by daye on 1/18/25.
//


import UIKit
import RxSwift
import SnapKit
import RxCocoa
import Then

// ex)
// private let agreeButton = CheckButton()
// agreeButton.configure(isBackground: true, title: "유의사항을 모두 확인했으며, 이에 동의합니다.")
// agreeButton.setState(isSelected: self.onTabCheckButton)

class CheckButton: UIButton {
 
    private let disposeBag = DisposeBag()
    private var isBackground = false
    
    private let icon = UIImageView().then {
        $0.image = UIImage(systemName: "checkmark.circle")
        $0.tintColor = .grayScale200
    }
    
    private let title = UILabel().then {
        $0.font = .pretenMedium(14)
        $0.textColor = .grayScale900
    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        self.layout()
    }
 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
        self.addSubview(icon)
        self.addSubview(title)
        
        icon.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
            $0.width.height.equalTo(20)
        }
        title.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(icon.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(16)
        }
    }
    
    func configure(isBackground: Bool, title: String) {
        self.layer.borderWidth = 0
        self.setTitleColor(.white, for: .normal)
        self.title.text = title
        if isBackground {
            self.isBackground = isBackground
            self.backgroundColor = .grayScale50
            self.layer.cornerRadius = 8
        }
    }
    
    func setState(isSelected: Bool) {
        print("백?\(isBackground)")
        UIView.animate(withDuration: 0.1) {
            switch isSelected {
            case true:
                self.icon.image = UIImage(systemName: "checkmark.circle.fill")
                self.icon.tintColor = .mainOrange500
                if self.isBackground {
                    self.backgroundColor = .mainOrange50
                }
            case false:
                self.icon.image = UIImage(systemName: "checkmark.circle")
                self.icon.tintColor = .grayScale200
                if self.isBackground {
                    self.backgroundColor = .grayScale50
                }
            }
        }
    }
}
