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

enum CommonButtonType {
    case enabled
    case disabled
    case selectedBorderStyle
    case unselectedBorderStyle
}

class CommonButton: UIButton {

    private let disposeBag = DisposeBag()
    var title: String
    var initialButtonType: CommonButtonType

    init(frame: CGRect = .zero, title: String, initialButtonType: CommonButtonType) {
        self.title = title
        self.initialButtonType = initialButtonType
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupButton() {
        setTitle(title, for: .normal)
        titleLabel?.font = .pretenSemiBold(16)
        layer.cornerRadius = 8
        clipsToBounds = true
        setState(initialButtonType)
    }
    
    func setState(_ state: CommonButtonType) {
        UIView.animate(withDuration: 0.1) {
            switch state {
            case .enabled:
                self.isEnabled = true
                self.backgroundColor = .mainOrange500
                self.layer.borderWidth = 0
                self.setTitleColor(.white, for: .normal)
            case .disabled:
                self.isEnabled = false
                self.backgroundColor = .grayScale100
                self.layer.borderWidth = 0
                self.setTitleColor(.grayScale500, for: .normal)
            case .selectedBorderStyle:
                self.isEnabled = true
                self.backgroundColor = .mainOrange50
                self.setTitleColor(.mainOrange500, for: .normal)
                self.layer.borderWidth = 1
                self.layer.borderColor = UIColor.mainOrange500.cgColor
            case .unselectedBorderStyle:
                self.isEnabled = true
                self.backgroundColor = .white
                self.setTitleColor(.grayScale200, for: .normal)
                self.layer.borderWidth = 1
                self.layer.borderColor = UIColor.grayScale200.cgColor
            }
        }
    }
}

extension Reactive where Base: CommonButton {
    var commonButtonState: Binder<CommonButtonType> {
        return Binder(self.base) { button, state in
            button.setState(state)
        }
    }
}
