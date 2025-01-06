//
//  InsightViewController.swift
//  imdang
//
//  Created by daye on 12/17/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Then

class InsightViewController: UIViewController {

    private let buttonTitles = ["기본 정보", "인프라", "단지 환경", "단지 시설", "호재"]
    private var selectedIndex = 0
    let disposeBag = DisposeBag()

    private let titleLabel = UILabel().then {
        $0.text = "인사이트 작성"
        $0.font = .pretenBold(20)
        $0.textColor = .grayScale900
    }

    private let backButton = UIButton().then {
        $0.setImage(ImdangImages.Image(resource: .backButton), for: .normal)
    }

    private let navigationLineView = UIView().then {
        $0.backgroundColor = .grayScale100
    }

    private let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 16
        $0.alignment = .fill
        $0.distribution = .fillProportionally
    }

    private let selectTabUnderLineView = UIView().then {
        $0.backgroundColor = .grayScale900
    }

    private let underLineView = UIView().then {
        $0.backgroundColor = .grayScale100
    }

    private let containerView = UIView().then {
        $0.backgroundColor = .clear
    }

    lazy var insightSubView: [UIViewController] = [
        EmptyViewController(labelText: "기본 정보"),
        WriteInsightEtcViewController(info: InsightEtcInfo.infrastructure, title: "인프라", selectType: .several),
        WriteInsightEtcViewController(info: InsightEtcInfo.environment, title: "단지 환경", selectType: .one),
        WriteInsightEtcViewController(info: InsightEtcInfo.facility, title: "단지 시설", selectType: .several),
        WriteInsightEtcViewController(info: InsightEtcInfo.goodNews, title: "호재", selectType: .several)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .grayScale25

        configNavigationBarItem()
        layout()
        setupButtons()
        bind()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if selectedIndex == 0, let firstButton = getButton(at: 0) {
            updateUnderlinePosition(for: firstButton)
        }
    }

    private func configNavigationBarItem() {
        let backgroundView = UIView()

        [backButton, titleLabel].forEach {
            backgroundView.addSubview($0)
        }

        backButton.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 6, bottom: 0, right: 0))
        }

        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(backButton.snp.trailing).offset(8)
            $0.centerY.equalTo(backButton.snp.centerY)
        }

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backgroundView)
    }

    private func layout() {
        [buttonStackView, navigationLineView, selectTabUnderLineView, underLineView, containerView].forEach { view.addSubview($0) }

        navigationLineView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.height.equalTo(1)
            $0.horizontalEdges.equalToSuperview()
        }

        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(navigationLineView.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }

        selectTabUnderLineView.snp.makeConstraints {
            $0.bottom.equalTo(buttonStackView.snp.bottom)
            $0.height.equalTo(3)
            $0.width.equalTo(0)
            $0.leading.equalToSuperview()
        }

        underLineView.snp.makeConstraints {
            $0.top.equalTo(selectTabUnderLineView.snp.bottom).offset(1)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }

        containerView.snp.makeConstraints {
            $0.top.equalTo(underLineView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        DispatchQueue.main.async {
            self.showInsightSubViewController(at: 0)
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

    private func bind() {
        backButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
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
            self.view.layoutIfNeeded()
        }
    }

    private func showInsightSubViewController(at index: Int) {
        children.forEach { $0.removeFromParent() }
        containerView.subviews.forEach { $0.removeFromSuperview() }

        let childVC = insightSubView[index]
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.snp.makeConstraints { $0.edges.equalToSuperview() }
        childVC.didMove(toParent: self)
    }
}
