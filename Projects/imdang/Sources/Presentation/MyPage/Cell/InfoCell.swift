//
//  InfoCell.swift
//  imdang
//
//  Created by daye on 1/19/25.
//

import UIKit
import SnapKit
import Then
import RxSwift

final class InfoCell: UITableViewCell {
    
    private let backView = UIView().then {
        $0.backgroundColor = .mainOrange50
        $0.layer.cornerRadius = 10
    }
    private let titleLabel = UILabel().then {
        $0.font = .pretenSemiBold(16)
        $0.textColor = UIColor.grayScale900
    }
    
    private let numberLabel = UILabel().then {
        $0.font = .pretenSemiBold(16)
        $0.textColor = UIColor.mainOrange500
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .grayScale25
        addSubViews()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubViews() {
        [titleLabel, numberLabel].forEach { backView.addSubview($0) }
        contentView.addSubview(backView)
    }
    
    private func layout() {

        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalTo(backView).inset(16)
            $0.leading.equalTo(backView).inset(20)
        }
        
        numberLabel.snp.makeConstraints {
            $0.top.bottom.equalTo(backView).inset(16)
            $0.trailing.equalTo(backView).inset(20)
        }
        
        backView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.bottom.equalToSuperview().inset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    func configure(title: String, num: String) {
        titleLabel.text = title
        numberLabel.text = num
    }
    
}
