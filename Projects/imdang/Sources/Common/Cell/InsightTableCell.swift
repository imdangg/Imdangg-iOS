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

    private let insightTableCell = InsightCellView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(insightTableCell)
        
        insightTableCell.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        insightTableCell.titleImageView.image = UIImage(systemName: "")
        insightTableCell.profileImageView.image = UIImage(systemName: "")

        insightTableCell.adressLabel.text = ""
        insightTableCell.likeLabel.text = ""
        insightTableCell.titleLabel.text = ""
        insightTableCell.userNameLabel.text = ""
        insightTableCell.resetConstraints()
        insightTableCell.directionType = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(insight: Insight, layoutType: DirectionType) {
        insightTableCell.configure(insight: insight, layoutType: layoutType)
    }
}
