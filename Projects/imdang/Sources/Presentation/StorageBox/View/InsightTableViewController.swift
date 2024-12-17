//
//  InsightTableViewController.swift
//  SharedLibraries
//
//  Created by 임대진 on 12/8/24.
//

import UIKit
import SnapKit
import Then

class InsightTableViewController: UIViewController {

    private let tableView = UITableView(/*frame: .zero, style: .insetGrouped*/)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(InsightTableCell.self, forCellReuseIdentifier: InsightTableCell.reuseIdentifier)
        tableView.separatorStyle = .none

        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }

}

extension InsightTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: InsightTableCell.reuseIdentifier, for: indexPath) as? InsightTableCell else {
            return UITableViewCell()
        }
        
        let testImage = "https://s3-alpha-sig.figma.com/img/bfd4/929c/86aa0d3566cba94912f0b4d10410b9b2?Expires=1733702400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=jVznuLFIzwecr875Ecx3wk6BTv7gmC1~-b0UoCUkxJI8rSjqu-NfEArK9bTrf~soTgQ9P8Dw-SGQaoN-k1R4nUTC1mz8Svwhdw7nd8YWWVbLO3a7nmdUH3oLTVfR0uqwvjJbVKPb7Pf3KQzXOHBp1o0JLhOt0sTYBMt8B2p47EYJe0QKTNrlmJDSQgJQCEyudHAyBl9WhC5CLU3UYHgN1VC9Ao6DbMkJusxmT3INQ3w-gHrvlovCvbLsBNvMTVlq4H7hAFzxLhR8ySqJ2cNzP7v-LyB2AwWIC15vYjs7lhctVXclsngtwPcUCSkaT53ghxo-TfB8bhZznInDWcTg0w__"
        let insight = Insight(id: 0, titleName: "초역세권 대단지 아파트 후기", titleImageUrl: testImage, userName: "홍길동", profileImageUrl: "", adress: "강남구 신논현동", likeCount: 20)
        cell.configure(insight: insight, layoutType: .horizontal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112
    }
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 12
//    }

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
}
