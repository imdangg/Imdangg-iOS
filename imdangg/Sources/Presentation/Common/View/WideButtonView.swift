//
//  WideButtonView.swift
//  imdangg
//
//  Created by daye on 11/11/24.
//
import UIKit
import SnapKit
import Then

class WideButtonView: UIView {
    
    let isEnabled: Bool
    let title: String
    
    private lazy var wideButton = UIButton().then {
        $0.setTitle(title, for: .normal)
        $0.setTitleColor(isEnabled ? .white : .grayScale500, for: .normal)
        $0.backgroundColor = isEnabled ? .mainOrange500 : .grayScale100
        $0.titleLabel?.font = FontUtility.getFont(type: .semiBold, size: 16)
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    init(frame: CGRect, title: String, isEnabled: Bool = false) {
        self.title = title
        self.isEnabled = isEnabled
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        self.title = ""
        self.isEnabled = false
        super.init(coder: coder)
    }
    
    private func setupView() {
        addSubview(wideButton)
        makeUI()
    }
    
    private func makeUI() {
        wideButton.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.leading.trailing.equalToSuperview()
        }
    }
}

