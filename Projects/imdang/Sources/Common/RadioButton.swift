//
//  RadioButton.swift
//  imdang
//
//  Created by 임대진 on 12/16/24.
//

import UIKit

class RadioButton: UIButton {
    let circle1 = UIImageView().then {
        $0.image = UIImage(systemName: "circle.fill")
        $0.tintColor = .grayScale100
    }
    let circle2 = UIImageView().then {
        $0.image = UIImage(systemName: "circle.fill")
        $0.tintColor = .white
    }
    let circle3 = UIImageView().then {
        $0.image = UIImage(systemName: "circle.fill")
        $0.tintColor = .grayScale100
    }
    var isSelect = false {
        didSet {
            circle3.tintColor = isSelect ? .mainOrange500 : .grayScale100
        }
    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func addSubviews() {
        [circle1, circle2, circle3].forEach {
            self.addSubview($0)
        }
    }
    
    func makeConstraints() {
        circle1.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(22)
        }
        circle2.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalTo(circle1)
            $0.width.height.equalTo(18)
        }
        circle3.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalTo(circle1)
            $0.width.height.equalTo(10)
        }
    }
}

class RadioButtonView: UIImageView {
    let circle1 = UIImageView().then {
        $0.image = UIImage(systemName: "circle.fill")
        $0.tintColor = .grayScale100
    }
    let circle2 = UIImageView().then {
        $0.image = UIImage(systemName: "circle.fill")
        $0.tintColor = .white
    }
    let circle3 = UIImageView().then {
        $0.image = UIImage(systemName: "circle.fill")
        $0.tintColor = .grayScale100
    }
    var isSelect = false {
        didSet {
            circle3.tintColor = isSelect ? .mainOrange500 : .grayScale100
        }
    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func addSubviews() {
        [circle1, circle2, circle3].forEach {
            self.addSubview($0)
        }
    }
    
    func makeConstraints() {
        circle1.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(22)
        }
        circle2.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalTo(circle1)
            $0.width.height.equalTo(18)
        }
        circle3.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalTo(circle1)
            $0.width.height.equalTo(10)
        }
    }
}
