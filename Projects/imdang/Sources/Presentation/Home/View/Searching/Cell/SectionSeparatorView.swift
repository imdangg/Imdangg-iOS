//
//  SectionSeparatorView.swift
//  imdang
//
//  Created by 임대진 on 12/4/24.
//

import UIKit

final class SectionSeparatorView: UICollectionReusableView {
    static let reuseIdentifier = "SectionSeparatorView"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = .grayScale50
    }
}

