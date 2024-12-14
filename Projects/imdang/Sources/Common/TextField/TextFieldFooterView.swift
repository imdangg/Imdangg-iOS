//
//  TextFieldFooterView.swift
//  imdang
//
//  Created by daye on 12/9/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Then

// bind > textFieldErrorMessage, textFieldState

class TextFieldFooterView: UIView {

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
        addSubview(errorMessageLabel)
    }
    
    private func makeUI() {
        errorMessageLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
    func setState(_ state: TextFieldState) {
        UIView.animate(withDuration: 0.1) {
            switch state {
            case .normal, .editing, .done:
                self.errorMessageLabel.text = ""
            case .error:
                return
            }
            self.layoutIfNeeded()
        }
    }
    
    func setErrorMessage(_ message: String) {
        errorMessageLabel.text = message
    }
}

extension Reactive where Base: TextFieldFooterView {
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

