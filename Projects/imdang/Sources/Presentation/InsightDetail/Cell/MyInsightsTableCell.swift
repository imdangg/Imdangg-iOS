//
//  MyInsightsTableCell.swift
//  imdang
//
//  Created by 임대진 on 1/26/25.
//

import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit

enum MyInsightsTableCellType {
    case ticket, insight
}

class MyInsightsTableCell: UITableViewCell {
    static let identifier = "MyInsightsTableCell"
    private var disposeBag = DisposeBag()
    
    private let lineView = UIImageView().then {
        $0.backgroundColor = .grayScale100
    }
    
    private let ticketBackgroundView = UIView().then {
        $0.backgroundColor = .mainOrange50
        $0.layer.cornerRadius = 2
        $0.clipsToBounds = true
    }
    
    private let ticketIcon = UIImageView().then {
        $0.image = ImdangImages.Image(resource: .ticket)
        $0.contentMode = .scaleAspectFit
    }
    
    private let ticketCountLabel = UILabel().then {
        $0.textColor = .mainOrange500
        $0.font = .pretenMedium(12)
    }
    
    private let addressBackgroundView = UIView().then {
        $0.backgroundColor = .grayScale50
        $0.layer.cornerRadius = 2
        $0.clipsToBounds = true
    }
    
    private let addressIcon = UIImageView().then {
        $0.image = ImdangImages.Image(resource: .location)
    }
    
    private let addressLabel = UILabel().then {
        $0.textColor = .grayScale700
        $0.font = .pretenMedium(12)
    }
    
    private let likeLabel = PaddingLabel().then {
        $0.textAlignment = .center
        $0.backgroundColor = .mainOrange50
        $0.layer.cornerRadius = 2
        $0.textColor = .mainOrange500
        $0.font = .pretenMedium(12)
        $0.clipsToBounds = true
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "아파트임당 패스권 사용"
        $0.textColor = .grayScale900
        $0.font = .pretenMedium(16)
    }
    
    private let selectButton = RadioButtonView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview()
    }
    
    override func prepareForReuse() {
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        self.selectButton.isSelect = selected ? true : false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubview() {
        [ticketIcon, ticketCountLabel].forEach { ticketBackgroundView.addSubview($0) }
        [addressIcon, addressLabel].forEach { addressBackgroundView.addSubview($0) }
        
        [ticketBackgroundView, addressBackgroundView, likeLabel, titleLabel, selectButton, lineView].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func makeConstraints(type: MyInsightsTableCellType) {
        switch type {
        case .ticket:
            ticketBackgroundView.snp.makeConstraints {
                $0.top.equalToSuperview().offset(16)
                $0.leading.equalToSuperview().offset(20)
                $0.height.equalTo(25)
            }
            
            ticketIcon.snp.makeConstraints {
                $0.top.equalToSuperview().offset(4.5)
                $0.leading.equalToSuperview().offset(8)
                $0.bottom.equalToSuperview().offset(-4.5)
                $0.width.height.equalTo(16)
            }
            
            ticketCountLabel.snp.makeConstraints {
                $0.centerY.equalTo(ticketIcon.snp.centerY)
                $0.leading.equalTo(ticketIcon.snp.trailing).offset(2)
                $0.trailing.equalToSuperview().offset(-8)
            }
            
            titleLabel.snp.makeConstraints {
                $0.top.equalTo(ticketBackgroundView.snp.bottom).offset(12)
                $0.leading.equalToSuperview().offset(20)
                $0.bottom.equalToSuperview().offset(-16)
                $0.height.equalTo(22)
            }
        case .insight:
            addressBackgroundView.snp.makeConstraints {
                $0.top.equalToSuperview().offset(16)
                $0.leading.equalToSuperview().offset(20)
                $0.height.equalTo(25)
            }
            
            addressIcon.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(8)
                $0.centerY.equalToSuperview()
                $0.width.height.equalTo(12)
            }
            
            addressLabel.snp.makeConstraints {
                $0.leading.equalTo(addressIcon.snp.trailing).offset(2)
                $0.trailing.equalToSuperview().offset(-8)
                $0.centerY.equalToSuperview()
            }
            
            likeLabel.snp.makeConstraints {
                $0.top.equalToSuperview().offset(16)
                $0.leading.equalTo(addressBackgroundView.snp.trailing).offset(4)
                $0.height.equalTo(25)
            }
            
            titleLabel.snp.makeConstraints {
                $0.top.equalTo(addressBackgroundView.snp.bottom).offset(12)
                $0.leading.equalToSuperview().offset(20)
                $0.bottom.equalToSuperview().offset(-16)
                $0.height.equalTo(22)
            }
        }
        
        selectButton.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        lineView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
    func config(type: MyInsightsTableCellType, ticketCount: Int? = 0, insight: Insight? = nil) {
        
        makeConstraints(type: type)
        
        if let count = ticketCount {
            ticketCountLabel.text = "\(count)개 보유"
        }
        
        if let insight = insight {
            addressLabel.text = insight.adress
            likeLabel.text = "추천 \(insight.likeCount)"
            titleLabel.text = insight.titleName
        }
    }
}
