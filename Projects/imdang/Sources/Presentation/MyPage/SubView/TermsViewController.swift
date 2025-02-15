//
//  TermsViewController.swift
//  imdang
//
//  Created by daye on 1/15/25.
//

import UIKit
import SnapKit
import Then

final class TermsViewController: BaseViewController {
   
    private let array: [String] = ["개인정보 수집 및 이용", "이용 약관"]
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    private let navigationTitleLabel = UILabel().then {
        $0.font = .pretenSemiBold(18)
        $0.textColor = .grayScale900
        $0.text = "서비스 이용 약관"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .grayScale25
        setUp()
        configNavigationBarItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AnalyticsService().screenEvent(ScreenName: .serviceTerms)
    }
    
    func setUp(){
        tableView.backgroundColor = .grayScale25
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.register(TermsCell.self, forCellReuseIdentifier: "TermsCell")
        
        view.addSubview(tableView)

        tableView.snp.makeConstraints {
            $0.topEqualToNavigationBottom(vc: self)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    private func configNavigationBarItem() {
        customBackButton.isHidden = false
        leftNaviItemView.addSubview(navigationTitleLabel)
        navigationTitleLabel.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
        }
    }
}

extension TermsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TermsCell", for: indexPath) as? TermsCell else {
            return UITableViewCell()
        }
        cell.configure(title: array[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        64
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.row == 0 {
            let vc =  MyPageWebViewController(title: "개인정보 수집 및 이용", urlString:   "https://principled-cry-2aa.notion.site/4d557e465d6143a3abc133397966c3d1?pvs=4")
            vc.hidesBottomBarWhenPushed = false
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 1 {
            let vc = MyPageWebViewController(title: "이용 약관", urlString:  "https://principled-cry-2aa.notion.site/54dd2a7ccd5a4c8193e06df782d02119?pvs=4")
            vc.hidesBottomBarWhenPushed = false
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
