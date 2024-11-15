//
//  WideButton.swift
//  imdang
//
//  Created by daye on 11/14/24.
//

import UIKit
import RxSwift
import SnapKit
import RxCocoa

// add View > width, height
// add Reactor > commonButtonTitle, commonButtonState, tap

enum CommonButtonState {
    case enabled
    case disabled
}

class CommonButton: UIButton {
    private let disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupButton() {
        setTitle("", for: .normal)
        titleLabel?.font = .pretenSemiBold(16)
        layer.cornerRadius = 8
        clipsToBounds = true
        setState(.enabled)
    }
    
    func setState(_ state: CommonButtonState) {
        switch state {
        case .enabled:
            isEnabled = true
            backgroundColor = .mainOrange500
            setTitleColor(.white, for: .normal)
        case .disabled:
            isEnabled = false
            backgroundColor = .grayScale100
            setTitleColor(.grayScale500, for: .normal)
        }
    }
}

extension Reactive where Base: CommonButton {
    var commonButtonTitle: Binder<String?> {
        return Binder(self.base) { button, title in
            button.setTitle(title, for: .normal)
        }
    }

    var commonButtonState: Binder<CommonButtonState> {
        return Binder(self.base) { button, state in
            button.setState(state)
        }
    }
}
