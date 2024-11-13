//
//  UserInfoEntryHeaderView.swift
//  imdangg
//
//  Created by daye on 11/12/24.
//

import UIKit
import SnapKit
import Then

enum NicknameInputError: String {
    case check = "~"
    // TODO: 이거 어케 처리할지 고민좀 해봐야겠음.
}

class UserInfoEntryHeaderView: UIView {
    
    var title: String
    var isVaildState: Bool
    var errorMessage: String

    private lazy var titleLabel = UILabel().then {
        $0.text = title
        $0.font = FontUtility.getFont(type: .medium, size: 14)
        $0.textColor = UIColor.grayScale600
    }
    
    var a = UIImage(systemName: "exclamationmark.circle.fill")
    
    private lazy var errorImage = UIImageView().then {
        $0.image = a
        $0.tintColor = isVaildState ? UIColor.mainOrange500 : UIColor.error
    }
    
    private lazy var errorMessageLabel = UILabel().then {
        $0.text = errorMessage
        $0.font = FontUtility.getFont(type: .medium, size: 14)
        $0.textColor = UIColor.error
    }
    
    init(frame: CGRect, title: String, isVaildState: Bool, errorMessage: String) {
       
        self.title = title
        self.isVaildState = isVaildState
        self.errorMessage = errorMessage
        super.init(frame: frame)
       
        addSubView()
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubView() {
        [titleLabel, errorImage, errorMessageLabel].forEach { addSubview($0) }
    }
    
    private func makeUI() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
        }
        errorImage.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(4)
        }
        errorMessageLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
        }
    }
    
}
