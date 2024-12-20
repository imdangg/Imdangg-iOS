//
//  AreaListViewController.swift
//  imdang
//
//  Created by 임대진 on 12/16/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class AreaListViewController: BaseViewController {
    private var tableView: UITableView!
    private let disposeBag = DisposeBag()
    
    private let confirmButton = UIButton().then {
        $0.setTitle("선택 완료", for: .normal)
        $0.backgroundColor = .orange
        $0.layer.cornerRadius = 8
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "지역 전체"
        $0.font = .pretenBold(20)
        $0.textColor = .grayScale900
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customBackButton.isHidden = false
        
        setupTableView()
        bindAction()
        addSubViews()
        makeConstraints()
        configNavigationBarItem()
        
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.backgroundColor = .white
        tableView.rowHeight = 80
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .grayScale100
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.showsVerticalScrollIndicator = false
        
        tableView.register(cell: AreaListTableCell.self)
    }
    
    private func configNavigationBarItem() {
        leftNaviItemView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func addSubViews() {
        
        view.addSubview(tableView)
        view.addSubview(confirmButton)
    }
    
    private func makeConstraints() {
        tableView.snp.makeConstraints {
            $0.topEqualToNavigationBottom(vc: self)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(confirmButton.snp.top)
        }
        
        confirmButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-40)
            $0.height.equalTo(56)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    private func bindAction() {
        confirmButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension AreaListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AreaListTableCell.identifier, for: indexPath)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
