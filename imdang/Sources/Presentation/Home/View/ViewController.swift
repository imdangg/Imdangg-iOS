//
//  ViewController.swift
//  Imdangg
//
//  Created by 임대진 on 11/3/24.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let testLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello, World!"
        return label
    }()
    let testLabel2: UILabel = {
        let label = UILabel()
        label.text = "Hello, World!"
        label.font = UIFont.systemFont(ofSize: 40)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        [testLabel, testLabel2].forEach { view.addSubview($0) }
        makeConstraints()
    }
    
    private func makeConstraints() {
        testLabel.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
        testLabel2.snp.makeConstraints { make in
            make.top.equalTo(testLabel.snp.bottom)
            make.centerX.equalTo(testLabel.snp.centerX)
        }
    }

}
