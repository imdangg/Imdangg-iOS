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
    
    var placeholderText: String
    var textfieldType: UIKeyboardType
   
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
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        self.leftView = leftView
        leftViewMode = .always
        self.backgroundColor = .white
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        autocapitalizationType = .none
        self.placeholder = placeholderText
    
        self.rightViewMode = .whileEditing
        self.clearButtonMode = .whileEditing
        self.keyboardType = textfieldType
    }
    
    func setState(_ state: TextFieldState) {
        UIView.animate(withDuration: 0.1) {
            print("setSatete: \(state)")
            switch state {
            case .normal, .done :
                self.layer.borderColor = UIColor.grayScale100.cgColor
            case .editing :
                self.layer.borderColor = UIColor.mainOrange500.cgColor
            case .error :
                self.layer.borderColor = UIColor.error.cgColor
            }
            self.setNeedsDisplay()
        }
    }
}

extension Reactive where Base: CommomTextField {
    var textFieldState: Binder<TextFieldState> {
        return Binder(self.base) { view, state in
            view.setState(state)
        }
    }
}

