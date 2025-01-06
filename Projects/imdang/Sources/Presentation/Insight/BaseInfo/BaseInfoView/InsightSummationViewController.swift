//
//  InsightSummationViewController.swift
//  imdang
//
//  Created by daye on 1/4/25.
//

import UIKit
import SnapKit
import Then

class InsightSummationViewController: UIViewController {

    private let noticeScriptView = NoticeScriptView()
    private let headerView = TextFieldHeaderView(title: "인사이트 요약", isEssential: true, descriptionText: "", limitNumber: 10)
    private let textView = UITextView().then {
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textColor = .black
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.borderWidth = 1.0
        $0.layer.cornerRadius = 8.0
        $0.isScrollEnabled = true // 여러 줄 작성 가능
        $0.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(noticeScriptView)
        view.addSubview(headerView)
        view.addSubview(textView)
       
        layout()
        noticeScriptView.configure(text: "교환을 위해 미리 공개하는 내용이에요. 잘 작성할수록 교환 성공률이 올라가요. 작성시 장점과 단점을 균형있게 작성해주세요.")
    }
    
    func layout() {
        noticeScriptView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview().inset(20)
        }
        
        headerView.snp.makeConstraints {
            $0.top.equalTo(noticeScriptView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        headerView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(180)
        }
    }
}
