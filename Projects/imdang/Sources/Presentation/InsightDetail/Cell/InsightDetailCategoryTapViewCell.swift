//
//  InsightDetailCategoryTapViewCell.swift
//  imdang
//
//  Created by 임대진 on 1/13/25.
//

import UIKit
import Then
import SnapKit

class InsightDetailCategoryTapViewCell: UICollectionReusableView {
    static let reuseIdentifier = "InsightDetailCategoryTapViewCell"
    private let view = InsightDetailCategoryTapView()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        addSubview(view)
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(44)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
