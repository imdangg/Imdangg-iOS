//
//  WideButtonView.swift
//  imdangg
//
//  Created by daye on 11/11/24.
//
import UIKit
import RxSwift
import RxCocoa

class WideButtonView: UIView, UIGestureRecognizerDelegate {
    
    private let disposeBag = DisposeBag()
    private let wideButton = UIButton()
    
    var isEnabled: Bool
    let title: String
    
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
        setupButton()
        makeUI()
    }
    
    private func setupButton() {
        wideButton.setTitle(title, for: .normal)
        wideButton.setTitleColor(isEnabled ? .white : .grayScale500, for: .normal)
        wideButton.backgroundColor = isEnabled ? .mainOrange500 : .grayScale100
        wideButton.titleLabel?.font = FontUtility.getFont(type: .semiBold, size: 16)
        wideButton.layer.cornerRadius = 8
        wideButton.clipsToBounds = true
        addSubview(wideButton)
    }
    
    private func makeUI() {
        wideButton.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.leading.trailing.equalToSuperview()
        }
    }
}
