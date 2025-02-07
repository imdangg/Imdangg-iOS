//
//  AddressTableCell.swift
//  imdang
//
//  Created by 임대진 on 2/5/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

final class AddressTableCell: UITableViewCell {
    static let identifier = "AddressTableCell"
    private var disposeBag = DisposeBag()
    
    private let label = UILabel().then {
        $0.font = .pretenSemiBold(16)
        $0.textColor = .grayScale900
        $0.textAlignment = .center
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        makeConstraints()
    }
    
    override func prepareForReuse() {
        label.text = ""
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        contentView.addSubview(label)
    }
    
    private func makeConstraints() {
        label.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func config(title: String) {
        label.text = title
    }
    
    func selectedCell(isSlected: Bool) {
        if isSlected {
            backgroundColor = .mainOrange500
            label.textColor = .white
        } else {
            backgroundColor = .white
            label.textColor = .grayScale500
        }
    }
}
