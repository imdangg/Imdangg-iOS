//
//  InsightDetailImageCell.swift
//  imdang
//
//  Created by 임대진 on 1/14/25.
//

import UIKit
import Then
import SnapKit

final class InsightDetailImageCell: UITableViewCell {
    static let identifier = "InsightDetailImageCell"
    
    private let insightImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(insightImageView)
        
        insightImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(300).priority(999)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        insightImageView.image = UIImage()
    }
    
    func config(url: String, mainImage: UIImage? = nil) {
        // 인사이트 작성후 보여지는 이미지 필요시
        if let image = mainImage {
            insightImageView.image = image
        } else {
            guard let url = URL(string: url) else {
                insightImageView.image = UIImage()
                return
            }
            insightImageView.kf.setImage(with: url)
            insightImageView.contentMode = .scaleAspectFill
        }
    }
}
