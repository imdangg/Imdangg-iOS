//
//  CustomSwitch.swift
//  imdang
//
//  Created by 임대진 on 1/7/25.
//

import UIKit
import Then
import SnapKit

class CustomSwitch: UIView {
    private var isOn: Bool = false
    private let thumbView = UIView()
    private let backgroundView = UIView()
    
    var valueChanged: ((Bool) -> Void)?
    
    init(width: Int = 32, height: Int = 18, thumbSize: CGSize = CGSize(width: 12, height: 12), isOn: Bool = false) {
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        self.isOn = isOn
        
        addSubviews()
        setupViews(thumbSize: thumbSize)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(backgroundView)
        addSubview(thumbView)
    }
    
    private func setupViews(thumbSize: CGSize) {
        backgroundView.do {
            $0.backgroundColor = isOn ? .mainOrange500 : .lightGray
            $0.layer.cornerRadius = frame.height / 2
            $0.isUserInteractionEnabled = false
        }
        
        thumbView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = thumbSize.height / 2
        }
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        thumbView.snp.makeConstraints { make in
            make.size.equalTo(thumbSize)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(3)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleSwitch))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func toggleSwitch() {
        isOn.toggle()
        UIView.animate(withDuration: 0.25) {
            self.updateUI()
        }
        valueChanged?(isOn)
    }
    
    private func updateUI() {
        backgroundView.backgroundColor = isOn ? .mainOrange500 : .lightGray
        thumbView.snp.updateConstraints { make in
            make.leading.equalToSuperview().offset(isOn ? frame.width - thumbView.frame.width - 3 : 3)
        }
        layoutIfNeeded()
    }
    
    func setOn(_ on: Bool, animated: Bool = true) {
        isOn = on
        if animated {
            UIView.animate(withDuration: 0.25) {
                self.updateUI()
            }
        } else {
            updateUI()
        }
    }
}
