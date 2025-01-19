//
//  Untitled.swift
//  imdang
//
//  Created by daye on 1/19/25.
//


import UIKit
import SnapKit
import Then

final class TermsDetailViewController: BaseViewController {
    private let titleLabel = UILabel()
    
    private let navigationTitleLabel = UILabel().then {
        $0.font = .pretenSemiBold(18)
        $0.textColor = .grayScale900
        $0.text = "이용 약관"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        set()
        configNavigationBarItem()
    }
    
    private func configNavigationBarItem() {
        customBackButton.isHidden = false
        leftNaviItemView.addSubview(navigationTitleLabel)
        navigationTitleLabel.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
        }
    }
    
    private func set() {
        view.addSubview(titleLabel)
        titleLabel.text = "이용 약관"
        titleLabel.snp.makeConstraints {
            $0.topEqualToNavigationBottom(vc: self).inset(50)
            $0.centerX.centerY.equalToSuperview()
        }
    }
}
