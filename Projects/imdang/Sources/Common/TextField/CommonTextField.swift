//
//  CommonTextField.swift
//  imdang
//
//  Created by daye on 11/17/24.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Then

// TODO: clear button, dateFormatter

enum TextFieldState {
    case normal
    case editing
    case done
    case error
}

class CommomTextField: UITextField {
    var isClearButtonTapped = BehaviorSubject<Bool>(value: false)
    let placeholderText: String
    let textfieldType: UIKeyboardType
    
    init(frame: CGRect = .zero, placeholderText: String, textfieldType: UIKeyboardType) {
        self.placeholderText = placeholderText
        self.textfieldType = textfieldType
        super.init(frame: frame)
        setAttribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAttribute() {
        self.font = .pretenSemiBold(16)
        self.layer.borderColor = UIColor.grayScale100.cgColor
        self.textColor = UIColor.grayScale900
        self.backgroundColor = .white
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        autocapitalizationType = .none
        
        self.placeholder = placeholderText
        self.keyboardType = textfieldType
        
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        clearButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        clearButton.tintColor = UIColor.grayScale200
        clearButton.contentEdgeInsets = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 16)
        
        self.rightView = clearButton
        self.rightViewMode = .whileEditing
        self.rightViewMode = .whileEditing
        
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        self.leftView = leftView
        leftViewMode = .always
        
        setupClearButtonAction()
    }
    
    func setupClearButtonAction() {
        if let clearButton = self.rightView as? UIButton {
            clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        }
    }
    
    func setState(_ state: TextFieldState) {
        UIView.animate(withDuration: 0.1) {
            print("setSatete: \(state)")
            switch state {
            case .normal:
                self.layer.borderColor = UIColor.grayScale100.cgColor
            case .done:
                self.layer.borderColor = UIColor.grayScale100.cgColor
            case .editing :
                self.layer.borderColor = UIColor.mainOrange500.cgColor
            case .error :
                self.layer.borderColor = UIColor.error.cgColor
            }
            self.setNeedsDisplay()
        }
    }
    
    @objc private func clearButtonTapped() {
        self.text = ""
        isClearButtonTapped.onNext(true)
    }
}

extension Reactive where Base: CommomTextField {
    var textFieldState: Binder<TextFieldState> {
        return Binder(self.base) { view, state in
            view.setState(state)
        }
    }
}

