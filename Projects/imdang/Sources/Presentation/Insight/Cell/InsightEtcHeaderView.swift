//
//  InsightEtcHeaderView.swift
//  imdang
//
//  Created by 임대진 on 12/30/24.
//

import UIKit
import Then

class InsightEtcHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "InsightEtcHeaderView"
    
    private let titleLabel = UILabel().then {
        $0.font = .pretenSemiBold(14)
        $0.textAlignment = .center
        $0.textColor = .grayScale700
    }
    
    private let subTitleLabel = PaddingLabel().then {
        $0.font = .pretenMedium(14)
        $0.textAlignment = .center
        $0.textColor = .grayScale600
        $0.backgroundColor = .grayScale50
        $0.padding = UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 8)
        
        $0.layer.cornerRadius = 4
        $0.clipsToBounds = true
    }
    
    private let descriptionLabel = UILabel().then {
        $0.font = .pretenMedium(12)
        $0.textAlignment = .center
        $0.textColor = .grayScale500
    }
    
    private let backView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubViews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = ""
        subTitleLabel.text = ""
        descriptionLabel.text = ""
    }
    
    private func addSubViews() {
        [titleLabel, descriptionLabel].forEach {
            backView.addSubview($0)
        }
        
        addSubview(backView)
    }
    
    private func makeConstraints() {
        backView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(20)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(20)
        }
    }
    
    func config(title: String, description: String, subtitle: String?) {
        titleLabel.text = title
        descriptionLabel.text = description
        if let subtitle {
            subTitleLabel.text = subtitle
            backView.addSubview(subTitleLabel)
            
            backView.snp.updateConstraints {
                $0.height.equalTo(84)
            }
            
            subTitleLabel.snp.makeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(8)
                $0.leading.equalToSuperview().offset(20)
                $0.height.equalTo(32)
            }
        } else {
            subTitleLabel.removeFromSuperview()
        }
        
        let attributedString = NSMutableAttributedString(string: title)
        let range = (title as NSString).range(of: "*")
        attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: range)
        
        titleLabel.attributedText = attributedString
    }
}
