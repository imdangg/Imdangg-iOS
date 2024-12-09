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

// bind > textFieldErrorMessage, textFieldState

class TextFieldHeaderView: UIView {
    
    let title: String
    let isEssential: Bool
    
    private var titleLabel = UILabel().then {
        $0.font = .pretenMedium(14)
        $0.textColor = UIColor.grayScale600
    }
    
    private var EssentialLabel = UILabel().then {
        $0.font = .pretenMedium(14)
        $0.text = "*"
        $0.textColor = UIColor.error
    }
    
    private var signImage = UIImageView()
    
    private var errorMessageLabel = UILabel().then {
        $0.font = .pretenMedium(14)
        $0.textColor = UIColor.error
    }
    
    init(frame: CGRect = .zero, title: String, isEssential: Bool) {
        self.title = title
        self.isEssential = isEssential
        super.init(frame: frame)
        attribute()
        addSubViews()
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attribute() {
        titleLabel.text = title
    }
    
    private func addSubViews() {
        [titleLabel, EssentialLabel, signImage, errorMessageLabel].forEach { addSubview($0) }
    }
    
    private func makeUI() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
        }
        
        if isEssential {
            EssentialLabel.snp.makeConstraints {
                $0.leading.equalTo(titleLabel.snp.trailing)
                $0.centerY.equalTo(titleLabel)
            }
            signImage.snp.makeConstraints {
                $0.leading.equalTo(EssentialLabel.snp.trailing).offset(4)
                $0.centerY.equalTo(titleLabel)
            }
        } else {
            signImage.snp.makeConstraints {
                $0.leading.equalTo(titleLabel.snp.trailing).offset(6)
                $0.centerY.equalTo(titleLabel)
            }
        }
    
        errorMessageLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(titleLabel)
        }
    }
    
    func setState(_ state: TextFieldState) {
        UIView.animate(withDuration: 0.1) {
            switch state {
            case .normal, .editing:
                self.signImage.alpha = 0.0
                self.errorMessageLabel.text = ""
            case .done:
                self.signImage.image = UIImage(systemName: "checkmark.circle.fill")
                self.signImage.tintColor = UIColor.mainOrange500
                self.signImage.alpha = 1.0
                self.errorMessageLabel.text = ""
            case .error:
                self.signImage.image = UIImage(systemName: "exclamationmark.circle.fill")
                self.signImage.alpha = 1.0
                self.signImage.tintColor = UIColor.error
            }
            
            self.layoutIfNeeded()
        }
    }
    
    func setErrorMessage(_ message: String) {
        errorMessageLabel.text = message
    }
}

// 네이밍,, 뭘로하는겨
extension Reactive where Base: TextFieldHeaderView {
    var textFieldErrorMessage: Binder<String> {
        return Binder(self.base) { view, message in
            view.setErrorMessage(message)
        }
    }

    var textFieldState: Binder<TextFieldState> {
        return Binder(self.base) { view, state in
            view.setState(state)
        }
    }
}

