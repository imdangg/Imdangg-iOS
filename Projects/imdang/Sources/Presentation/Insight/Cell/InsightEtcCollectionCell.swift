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
    
    private let label = UILabel().then {
        $0.backgroundColor = .white
        $0.font = .pretenMedium(16)
        $0.textColor = .grayScale400
        $0.textAlignment = .center
        
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
        super.prepareForReuse()
        
        unSeleted()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubview() {
        contentView.addSubview(label)
    }
    
    private func makeConstraints() {
        label.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func config(buttonTitle: String) {
        label.text = buttonTitle
    }
    
    func isSeleted() {
        label.backgroundColor = .mainOrange50
        label.textColor = .mainOrange500
        label.layer.borderColor = UIColor.mainOrange500.cgColor
    }
    
    func unSeleted() {
        label.backgroundColor = .white
        label.textColor = .grayScale400
        label.layer.borderColor = UIColor.grayScale100.cgColor
    }
}
