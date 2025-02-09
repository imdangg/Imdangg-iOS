//
//  TitleCell.swift
//  imdang
//
//  Created by daye on 12/29/24.
//

import UIKit
import SnapKit
import Then
import RxSwift

class BaseInfoTextFieldCell: UICollectionViewCell {
    static let identifier = "TitleCell"
    var disposeBag = DisposeBag()
    var didTappedClearButton: (() -> Void)?
    
    let titleTextField = CommomTextField(placeholderText: "", textfieldType: .stringInput, limitNum: 20).then {
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .grayScale900
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        contentView.addSubview(titleTextField)
        titleTextField.snp.makeConstraints {
            $0.height.equalTo(52)
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
    private func bind() {
        titleTextField.isClearButtonTapped
            .subscribe(onNext: { [weak self] bool in
                guard let self = self else { return }
                titleTextField.text = ""
                didTappedClearButton?()
            })
            .disposed(by: disposeBag)
    }

}
