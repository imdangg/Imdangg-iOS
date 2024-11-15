//
//  SectionHeaderView.swift
//  imdang
//
//  Created by daye on 11/15/24.
//
import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Then

// View init > userInfoEntryHeaderView.setTitle("Hi")
// bind > textFieldErrorMessage, textFieldState


// 임시. textfield의 state로 변경될예정
enum headerState {
    case normal
    case done
    case error
}

class UserInfoEntryHeaderView: UIView {
    
    private var titleLabel = UILabel().then {
        $0.font = .pretenMedium(14)
        $0.textColor = UIColor.grayScale600
    }
    
    private var signImage = UIImageView()
    
    private var errorMessageLabel = UILabel().then {
        $0.font = .pretenMedium(14)
        $0.textColor = UIColor.error
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
        [titleLabel, signImage, errorMessageLabel].forEach { addSubview($0) }
    }
    
    private func makeUI() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
        }
        signImage.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(4)
        }
        errorMessageLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
        }
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    func setState(_ state: headerState) {
        switch state {
        case .normal:
            signImage.isHidden = true
            errorMessageLabel.text = ""
        case .done:
            signImage.isHidden = false
            signImage.image = UIImage(systemName: "checkmark.circle.fill")
            signImage.tintColor = UIColor.mainOrange500
            errorMessageLabel.text = ""
        case .error:
            signImage.image = UIImage(systemName: "exclamationmark.circle.fill")
            signImage.isHidden = false
            signImage.tintColor = UIColor.error
        }
    }
    
    func setErrorMessage(_ message: String) {
        errorMessageLabel.text = message
    }
}

// 네이밍,, 뭘로하는겨
extension Reactive where Base: UserInfoEntryHeaderView {
    var textFieldErrorMessage: Binder<String> {
        return Binder(self.base) { view, message in
            view.setErrorMessage(message)
        }
    }

    var textFieldState: Binder<headerState> {
        return Binder(self.base) { view, state in
            view.setState(state)
        }
    }
}
