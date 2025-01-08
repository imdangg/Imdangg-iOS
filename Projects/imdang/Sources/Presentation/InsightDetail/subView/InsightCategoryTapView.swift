//
//  InsightCategoryTapView.swift
//  imdang
//
//  Created by 임대진 on 1/8/25.
//
import UIKit
import Then
import SnapKit

class InsightCategoryTapView: UIView {
    private let buttonTitles = ["기본 정보", "인프라", "단지 환경", "단지 시설", "호재"]
    private var selectedIndex = 0

    private let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 16
        $0.alignment = .fill
        $0.distribution = .fillProportionally
    }

    private let selectTabUnderLineView = UIView().then {
        $0.backgroundColor = .grayScale900
    }
    
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.layer.borderColor = UIColor.grayScale100.cgColor
        self.layer.borderWidth = 1
        
        addSubviews()
        makeConstraints()
        setupButtons()
        
        if selectedIndex == 0, let firstButton = getButton(at: 0) {
            updateUnderlinePosition(for: firstButton)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        [buttonStackView, selectTabUnderLineView].forEach { addSubview($0) }
    }
    
    private func makeConstraints() {
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(4)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }

        selectTabUnderLineView.snp.makeConstraints {
            $0.bottom.equalTo(buttonStackView.snp.bottom)
            $0.height.equalTo(3)
            $0.width.equalTo(0)
            $0.leading.equalToSuperview()
        }
    }
    
    private func setupButtons() {
        buttonTitles.enumerated().forEach { index, title in
            let button = UIButton()
            button.setTitle(title, for: .normal)
            button.setTitleColor(index == selectedIndex ? .grayScale900 : .grayScale500, for: .normal)
            button.titleLabel?.font = .pretenSemiBold(14)
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.titleLabel?.minimumScaleFactor = 0.8
            button.titleLabel?.lineBreakMode = .byTruncatingTail
            button.tag = index

            button.addTarget(self, action: #selector(didTapTabButton(_:)), for: .touchUpInside)
            buttonStackView.addArrangedSubview(button)
        }
    }
    
    private func getButton(at index: Int) -> UIButton? {
        return buttonStackView.arrangedSubviews[index] as? UIButton
    }

    @objc private func didTapTabButton(_ sender: UIButton) {
        selectedIndex = sender.tag

        for (index, button) in buttonStackView.arrangedSubviews.enumerated() {
            let btn = button as! UIButton
            btn.setTitleColor(index == selectedIndex ? .grayScale900 : .grayScale500, for: .normal)
        }

        if let button = getButton(at: selectedIndex) {
            UIView.animate(withDuration: 0.2) {
                self.updateUnderlinePosition(for: button)
            }
        }

        showInsightSubViewController(at: selectedIndex)
    }
    
    private func updateUnderlinePosition(for button: UIButton) {
        selectTabUnderLineView.snp.remakeConstraints {
            $0.bottom.equalTo(buttonStackView)
            $0.height.equalTo(3)
            $0.width.equalTo(button.titleLabel?.intrinsicContentSize.width ?? 0)
            $0.centerX.equalTo(button)
        }
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }
    
    private func showInsightSubViewController(at index: Int) {
    }
    func config(info: InsightDetail) {
    }
}
