//
//  UserCell.swift
//  imdang
//
//  Created by daye on 1/19/25.
//

import UIKit
import SnapKit
import Then
import RxSwift

final class UserCell: UITableViewCell {
    
    let disposeBag = DisposeBag()
    
    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = ImdangImages.Image(resource: .person)
        $0.clipsToBounds = true
    }
    
    private let userNameLabel = UILabel().then {
        $0.font = .pretenSemiBold(18)
        $0.textColor = UIColor.grayScale900
    }
    
    private let logoutButton = ImageTextButton(type: .imageFirst, horizonPadding: 12, spacing: 4).then {
        $0.customImage.image = ImdangImages.Image(resource: .logout)
        $0.customText.text = "로그아웃"
        $0.customText.font = .pretenMedium(12)
        $0.customText.textColor = .grayScale700
        $0.imageSize = 11
       
        $0.layer.cornerRadius = 4
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.grayScale200.cgColor
    }
    
    var onLogoutButtonTapped: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .grayScale25
        addSubViews()
        layout()
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addSubViews() {
        [profileImageView, userNameLabel, logoutButton].forEach { contentView.addSubview($0) }
    }
    
    private func layout() {
        profileImageView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview().inset(20)
            $0.width.height.equalTo(60)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView.snp.centerY)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(15)
            $0.width.lessThanOrEqualTo(134)
        }
        
        logoutButton.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView.snp.centerY)
            $0.width.equalTo(82)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func bind() {
        logoutButton.rx.tap
            .subscribe(onNext: {
                self.onLogoutButtonTapped?()
            })
            .disposed(by: disposeBag)
    }
    
    func configure(name: String) {
        userNameLabel.text = name
    }
}
