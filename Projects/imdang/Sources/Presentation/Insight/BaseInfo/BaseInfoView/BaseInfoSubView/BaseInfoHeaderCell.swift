//
//  BaseInfoHeaderCell.swift
//  imdang
//
//  Created by daye on 12/29/24.
//

import UIKit

class BaseInfoHeaderCell: UICollectionReusableView {
    static let identifier = "BaseInfoHeaderCell"
    
    let headerView = TextFieldHeaderView(title: "", isEssential: true, descriptionText: "", limitNumber: 10)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headerView)
        
        headerView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, script: String) {
        headerView.setConfigure(title: title, script: script, limitNumber: 0)
    }
    
    func adjustTopPadding(_ padding: CGFloat) {
        headerView.snp.updateConstraints {
            $0.top.equalToSuperview().offset(padding)
        }
    }
    
    private func bind() {
        
    }
}



