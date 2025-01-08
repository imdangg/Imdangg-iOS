//
//  InsightCollectionCell.swift
//  SharedLibraries
//
//  Created by 임대진 on 11/26/24.
//

import UIKit
import SnapKit
import Then

class InsightCollectionCell: UICollectionViewCell {
    static let identifier = "InsightCollectionCell"

    private let insightCellView = InsightCellView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(insightCellView)
        
        insightCellView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        insightCellView.titleImageView.image = UIImage(systemName: "")
        insightCellView.profileImageView.image = UIImage(systemName: "")

        insightCellView.adressLabel.text = ""
        insightCellView.likeLabel.text = ""
        insightCellView.titleLabel.text = ""
        insightCellView.userNameLabel.text = ""
        insightCellView.resetConstraints()
        insightCellView.directionType = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(insight: InsightCell, layoutType: DirectionType) {
        insightCellView.configure(insight: insight, layoutType: layoutType)
    }
}
