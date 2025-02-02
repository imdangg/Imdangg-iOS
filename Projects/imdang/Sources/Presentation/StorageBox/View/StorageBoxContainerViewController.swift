//
//  StorageBoxContainerViewController.swift
//  imdang
//
//  Created by 임대진 on 2/2/25.
//

import UIKit
import SnapKit
import Then

class StorageBoxContainerViewController: UIViewController {
    private let insight = [Insight]()
    private let emptyView = StorageBoxEmptyViewController()
    private let storageBoxViewController = StorageBoxViewController()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        addSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        addChild(emptyView)
        addChild(storageBoxViewController)
        
        [emptyView.view, storageBoxViewController.view].forEach { view.addSubview($0) }
        
        emptyView.didMove(toParent: self)
        storageBoxViewController.didMove(toParent: self)
    }
    
    private func makeConstraints() {
        if !insight.isEmpty {
            storageBoxViewController.view.isHidden = true
        } else {
            emptyView.view.isHidden = true
        }
    }
}
