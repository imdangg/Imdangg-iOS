//
//  InsightEtcCollectionCell.swift
//  imdang
//
//  Created by 임대진 on 12/30/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class InsightEtcCollectionCell: UICollectionViewCell {
    static let identifier = "InsightEtcCollectionCell"
    
    private let button = UIButton().then {
        $0.backgroundColor = .white
        $0.titleLabel?.font = .pretenMedium(16)
        $0.setTitleColor(.grayScale400, for: .normal)
        
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.grayScale100.cgColor
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview()
        makeConstraints()
    }
    
    override func prepareForReuse() {
        button.setTitle("", for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubview() {
        contentView.addSubview(button)
    }
    
    private func makeConstraints() {
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func config(buttonTitle: String) {
        button.setTitle(buttonTitle, for: .normal)
    }
}
