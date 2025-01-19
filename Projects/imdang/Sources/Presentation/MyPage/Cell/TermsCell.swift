//
//  Untitled.swift
//  imdang
//
//  Created by daye on 1/19/25.
//

import UIKit
import SnapKit
import Then
import RxSwift

final class TermsCell: UITableViewCell {

    private let titleLabel = UILabel().then {
        $0.font = .pretenSemiBold(16)
        $0.textColor = UIColor.grayScale900
    }
    
    private let versionLabel = UILabel().then {
        $0.font = .pretenMedium(14)
        $0.textColor = UIColor.grayScale600
    }
    
    private let navigationButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.forward"), for: .normal)
        $0.tintColor = .grayScale900
    }
    
    private let separator = UIView().then {
        $0.backgroundColor = .grayScale100
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .grayScale25
        addSubViews()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
        [titleLabel, versionLabel, navigationButton, separator].forEach { contentView.addSubview($0) }
    }
    
    private func layout() {
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(20)
        }
        
        versionLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
        
        navigationButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
            $0.width.height.equalTo(16)
        }
        
        separator.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
    func configure(title: String, version: String? = nil) {
        titleLabel.text = title
        
        if let version = version {
            versionLabel.isHidden = false
            navigationButton.isHidden = true
            versionLabel.text = version
        } else {
            versionLabel.isHidden = true
            navigationButton.isHidden = false
        }
    }
}
