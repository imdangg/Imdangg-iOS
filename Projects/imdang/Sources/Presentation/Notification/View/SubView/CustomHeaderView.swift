//
//  Untitled.swift
//  imdang
//
//  Created by markany on 1/20/25.
//

import UIKit
import SnapKit
import Then

final class CustomHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "CustomHeaderView"

    private let titleLabel = UILabel().then {
        $0.font = .pretenBold(22)
        $0.textColor = .grayScale900
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.verticalEdges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String) {
        titleLabel.text = title
    }

}
