//
//  OnboardingViewController.swift
//  imdang
//
//  Created by 임대진 on 11/13/24.
//

import UIKit
import Then
import SnapKit

class OnboardingViewController: UIViewController {
    private let titleLabel = UILabel().then {
        $0.font = .pretenBold(24)
    }
    
    private let descriptionLabel = UILabel().then {
        $0.font = .pretenLight(16)
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }
    
    private let backView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let guideImageView = UIImageView()
    private let coverView = UIImageView().then { $0.backgroundColor = .white }.then { $0.isHidden = true }
    private let imageButton = CommonButton(title: "교환 요청", initialButtonType: .enabled).then { $0.isHidden = true }
    
    init(title: String, description: String, image: UIImage) {
        super.init(nibName: nil, bundle: nil)
        titleLabel.text = title
        descriptionLabel.text = description
        guideImageView.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    private func setupLayout() {
        [guideImageView, coverView, imageButton, backView, titleLabel, descriptionLabel].forEach(view.addSubview)
        guideImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(backView.snp.top)
        }
        
        coverView.snp.makeConstraints {
            $0.top.equalTo(imageButton.snp.top)
            $0.horizontalEdges.equalTo(guideImageView.snp.horizontalEdges).inset(36)
            $0.height.equalTo(80)
        }
        
        imageButton.snp.makeConstraints {
            $0.horizontalEdges.equalTo(coverView)
            $0.height.equalTo(37)
            $0.bottom.equalTo(backView.snp.top).offset(-8)
        }
        
        backView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(289)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(backView.snp.top).offset(72)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
    }
    
    func showButton() {
        coverView.isHidden = false
        imageButton.isHidden = false
    }
}
