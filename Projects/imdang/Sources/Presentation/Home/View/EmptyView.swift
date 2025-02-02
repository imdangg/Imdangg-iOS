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
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        makeConstraints()
    }
    
    private func addSubviews() {
        
    }
    
    private func makeConstraints() {
    }
}
