//
//  NewExchangeViewController.swift
//  imdang
//
//  Created by daye on 1/9/25.
//
import UIKit
import RxSwift
import SnapKit
import ReactorKit

enum ExchangeRequestState {
    case request
    case receive
}

final class ExchangeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, View {
    
    let searchingViewModel = SearchingViewModel()
    var disposeBag = DisposeBag()
    private let tableView = UITableView(frame: .zero, style: .plain)
    private var insights: [Insight] = []

    init(reactor: ExchangeReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        reactor?.action.onNext(.loadInsights)
    }


    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ExchangeHeaderCell.self, forCellReuseIdentifier: "ExchangeHeaderCell")
        tableView.register(InsightTableCell.self, forCellReuseIdentifier: "InsightTableCell")
        tableView.rowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func bind(reactor: ExchangeReactor) {
        reactor.state
            .compactMap { $0.insights }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] insights in
                self?.insights = insights
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        reactor.state
                .map { $0.selectedExchangeState }
                .distinctUntilChanged()
                .subscribe(onNext: { [weak self] _ in
                    guard let self = self, self.tableView.window != nil else { return }
                    self.tableView.beginUpdates()
                    self.tableView.endUpdates()
                })
                .disposed(by: disposeBag)
    }


    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return insights.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 6
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExchangeHeaderCell", for: indexPath) as! ExchangeHeaderCell
            cell.bind(reactor: reactor!)
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InsightTableCell", for: indexPath) as! InsightTableCell
            cell.configure(insight: insights[indexPath.row], layoutType: .horizontal)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            let baseHeight: CGFloat = 300
            if reactor?.currentState.selectedExchangeState == .done {
                return baseHeight + 20
            } else {
                return baseHeight
            }
        } else {
            return 112
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 { return }
        print("\(indexPath.row)")
        searchingViewModel.loadInsightDetail(id: insights[indexPath.row].insightId)
            .subscribe { [self] data in
                if let data = data {
                    let vc = InsightDetailViewController(insight: data)
                    vc.hidesBottomBarWhenPushed = true
                    navigationController?.pushViewController(vc, animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
}
