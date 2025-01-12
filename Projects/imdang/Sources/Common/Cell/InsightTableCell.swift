//
//  InsightTableCell.swift
//  SharedLibraries
//
//  Created by 임대진 on 12/8/24.
//

import UIKit
import SnapKit
import Then

class InsightTableCell: UITableViewCell {
    static let identifier = "InsightTableCell"

    private let insightCellView = InsightCellView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(insightCellView)
        
        insightCellView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
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

    func configure(insight: Insight, layoutType: DirectionType) {
        insightCellView.configure(insight: insight, layoutType: layoutType)
    }
}
