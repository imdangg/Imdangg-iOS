//
//  AreaModalViewController.swift
//  imdang
//
//  Created by 임대진 on 12/16/24.
//


import UIKit
import SnapKit
import RxSwift
import RxCocoa

class AreaModalViewController: UIViewController {
    private var tableView: UITableView!
    private let disposeBag = DisposeBag()
    private let grabber = UIButton().then {
        $0.backgroundColor = .grayScale200
        $0.layer.cornerRadius = 3
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupTableView()
        
        if let sheetPresentationController = sheetPresentationController {
            sheetPresentationController.detents = [.medium(), .large()]
        }
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.rowHeight = 62
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView(tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        
        tableView.register(cell: AreaModalTableCell.self)
        
        view.addSubview(tableView)
        view.addSubview(grabber)
        
        grabber.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(52)
            $0.height.equalTo(6)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(grabber.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
    }
}

extension AreaModalViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AreaModalTableCell.identifier, for: indexPath)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
