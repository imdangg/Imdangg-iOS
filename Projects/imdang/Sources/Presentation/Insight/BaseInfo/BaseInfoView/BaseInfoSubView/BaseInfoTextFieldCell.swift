//
//  TitleCell.swift
//  imdang
//
//  Created by daye on 12/29/24.
//

import UIKit
import SnapKit
import Then

class BaseInfoTextFieldCell: UICollectionViewCell {
    static let identifier = "TitleCell"
    
    let titleTextField = CommomTextField(placeholderText: "", textfieldType: .stringInput ).then {
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .grayScale900
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
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
}
