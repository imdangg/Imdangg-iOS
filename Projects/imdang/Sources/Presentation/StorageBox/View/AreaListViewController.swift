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

class AreaListViewController: UIViewController {
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
    
    private let backButton = UIButton().then {
        $0.setImage(ImdangImages.Image(resource: .backButton), for: .normal)
    }
    private let navigationLineView = UIView().then {
        $0.backgroundColor = .grayScale100
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupTableView()
        bindAction()
        addSubViews()
        makeConstraints()
        configNavigationBarItem()
        
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.rowHeight = 80
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .grayScale100
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.showsVerticalScrollIndicator = false
        
        tableView.register(cell: AreaListTableCell.self)
    }
    
    private func configNavigationBarItem() {
        let backgroundView = UIView()
        
        [backButton, titleLabel].forEach {
            backgroundView.addSubview($0)
        }
        
        backButton.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 4, bottom: 0, right: 0))
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(backButton.snp.trailing).offset(8)
            $0.centerY.equalTo(backButton.snp.centerY)
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backgroundView)
    }
    
    private func addSubViews() {
        
        view.addSubview(tableView)
        view.addSubview(confirmButton)
        view.addSubview(navigationLineView)
    }
    
    private func makeConstraints() {
        navigationLineView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.height.equalTo(1)
            $0.horizontalEdges.equalToSuperview()
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(navigationLineView.snp.bottom)
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
        backButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
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
