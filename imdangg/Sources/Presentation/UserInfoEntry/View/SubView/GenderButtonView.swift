//
//  GenderButtonView.swift
//  imdangg
//
//  Created by daye on 11/12/24.
//

import UIKit
import SnapKit
import Then

enum Gender: String {
    case none = ""
    case man = "남자"
    case woman = "여자"
}

class GenderButtonView: UIView {
    
    let titleGender: Gender
    var userGender: Gender
    
    private lazy var genderButton = UIButton().then {
        $0.setTitle(titleGender.rawValue, for: .normal)
        $0.setTitleColor((userGender == titleGender) ? .mainOrange500 : .grayScale500, for: .normal)
        $0.backgroundColor = (userGender == titleGender) ? .mainOrange50 : .white
        $0.titleLabel?.font = FontUtility.getFont(type: .semiBold, size: 16)
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = ((userGender == titleGender) ? UIColor.mainOrange500.cgColor : UIColor.grayScale100.cgColor)
        $0.clipsToBounds = true
    }
    
    init(frame: CGRect, userGender: Gender, titleGender: Gender) {
        self.userGender = userGender
        self.titleGender = titleGender
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        self.userGender = Gender.none
        self.titleGender = Gender.man
        super.init(coder: coder)
    }
    
    private func setupView() {
        addSubview(genderButton)
        makeUI()
    }
    
    private func makeUI() {
        genderButton.snp.makeConstraints {
            $0.height.equalTo(52)
            $0.leading.trailing.equalToSuperview()
        }
    }
}
