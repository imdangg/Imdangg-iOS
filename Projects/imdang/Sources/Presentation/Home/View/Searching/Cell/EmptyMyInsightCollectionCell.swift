//
//  EmptyMyInsightCollectionCell.swift
//  imdang
//
//  Created by 임대진 on 1/21/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class EmptyMyInsightCollectionCell: UICollectionViewCell {
    static let identifier = "EmptyMyInsightCollectionCell"
    
    private let imageView = UIImageView().then {
        $0.image = ImdangImages.Image(resource: .emptyMyInsight)
        $0.contentMode = .scaleAspectFill
    }
    
    private let label = UILabel().then {
        $0.font = .pretenMedium(14)
        $0.textColor = .grayScale500
        $0.numberOfLines = 0
        $0.setTextWithLineHeight(text: "아직 작성한 내역이 없어요\n임장을 다녀온 후 인사이트를 작성해보세요", lineHeight: 19.6)
        $0.textAlignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview()
        makeConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubview() {
        contentView.addSubview(imageView)
        contentView.addSubview(label)
    }
    
    private func makeConstraints() {
        imageView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(72)
        }
        
        label.snp.makeConstraints {
            $0.center.equalTo(imageView)
        }
    }
}
