//
//  InsightTotalAppraisalView.swift
//  imdang
//
//  Created by 임대진 on 1/3/25.
//

import UIKit
import Then
import SnapKit

class InsightTotalAppraisalFooterView: UICollectionReusableView {
    static let identifier = "InsightTotalAppraisalFooterView"
    
    private let titleLabel = UILabel().then {
        $0.font = .pretenSemiBold(14)
        $0.textColor = .grayScale700
    }
    
    private let descriptionLabel = UILabel().then {
        $0.text = "최소30자-최대200자"
        $0.font = .pretenMedium(12)
        $0.textColor = .grayScale500
    }
    
    private let editFieldButton = UIButton().then {
        $0.backgroundColor = .white
        
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.grayScale100.cgColor
        $0.layer.cornerRadius = 8
    }
    
    private let backView = UIView()
    private let scrollView = UIScrollView()
    private let textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        [titleLabel, descriptionLabel, editFieldButton].forEach { addSubview($0) }
    }
    
    private func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(25.5)
            $0.leading.equalToSuperview().offset(20)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(25.5)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        editFieldButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(180)
        }
    }
    
    func config(title: String) {
        titleLabel.text = title
    }
}
