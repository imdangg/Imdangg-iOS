//
//  AreaModalTableCell.swift
//  imdang
//
//  Created by 임대진 on 12/16/24.
//

import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit

class AreaModalTableCell: UITableViewCell {
    static let identifier = "AreaModalTableCell"
    
    private let titleLabel = UILabel().then {
        $0.font = .pretenMedium(16)
        $0.textColor = .grayScale900
    }
    
    private let countLabel = UILabel().then {
        $0.font = .pretenMedium(14)
        $0.textColor = .mainOrange500
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.layer.cornerRadius = 8
        contentView.backgroundColor = .grayScale25
        addSubview()
        makeConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0))
    }
    
    override func prepareForReuse() {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubview() {
        [titleLabel, countLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
        
        countLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
        }
    }
    
    func config(apt: AptComplexByDistrict?) {
        guard let apt else { return }
        titleLabel.text = apt.apartmentComplexName
        countLabel.text = "\(apt.insightCount)개"
    }
}
