//
//  SearchingSectionHeaderView.swift
//  imdang
//
//  Created by 임대진 on 11/26/24.
//

import UIKit

enum HeaderType {
    case topten
    case notTopten
}

class SearchingSectionHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "SearchingSectionHeaderView"
    private var headerType: HeaderType = .notTopten
    
    private let titleLabel = UILabel().then {
        $0.font = .pretenSemiBold(18)
        $0.textColor = .grayScale900
        $0.numberOfLines = 1
    }
    
    private let fullViewBotton = UIButton().then {
        $0.setTitle("전체보기", for: .normal)
        $0.titleLabel?.font = .pretenRegular(14)
        $0.setTitleColor(.grayScale700, for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String, type: HeaderType) {
        titleLabel.text = title
        headerType = type
        
        if type == .topten {
            let attributedString = NSMutableAttributedString(string: title)
            let range = (title as NSString).range(of: "TOP 10")
            attributedString.addAttribute(.foregroundColor, value: UIColor.mainOrange500, range: range)
            
            titleLabel.attributedText = attributedString
        } else {
            addSubview(fullViewBotton)
            fullViewBotton.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.trailing.equalToSuperview()
            }
        }
    }
}
