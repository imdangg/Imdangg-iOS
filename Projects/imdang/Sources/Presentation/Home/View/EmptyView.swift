//
//  EmptyView.swift
//  imdang
//
//  Created by 임대진 on 11/20/24.
//

import UIKit
import SnapKit
import Then

class EmptyViewController: UIViewController {
    
    private let centerLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 18)
    }
    
    private let labelText: String
    
    init(labelText: String) {
        self.labelText = labelText
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        centerLabel.text = labelText
        
        makeConstraints()
    }
    
    private func makeConstraints() {
        view.addSubview(centerLabel)
        
        centerLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
