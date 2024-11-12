//
//  OnboardingViewController.swift
//  imdang
//
//  Created by 임대진 on 11/13/24.
//

import UIKit

class OnboardingViewController: UIViewController {
    private let titleLabel = UILabel().then {
        $0.font = .pretenBold(24)
    }
    
    private let descriptionLabel = UILabel().then {
        $0.font = .pretenLight(16)
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }
    
    init(title: String, description: String) {
        super.init(nibName: nil, bundle: nil)
        titleLabel.text = title
        descriptionLabel.text = description
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    private func setupLayout() {
        [titleLabel, descriptionLabel].forEach(view.addSubview)
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(72)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
    }
}
