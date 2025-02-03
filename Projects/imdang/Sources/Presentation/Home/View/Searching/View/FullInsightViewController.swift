//
//  FullInsightViewController.swift
//  imdang
//
//  Created by 임대진 on 2/1/25.
//

import UIKit
import SnapKit
import RxSwift
import RxRelay

enum FullInsightType: String {
    case my = "내가 다녀온 단지의 다른 인사이트"
    case today = "오늘 새롭게 올라온 인사이트"
    case search
}

class FullInsightViewController: BaseViewController {
    private var pageIndex = 0
    private var totalPage = 1
    private var tableView: UITableView!
    private var chipViewHidden: Bool = false
    private var myInsights: [Insight]?
    private var insightType: FullInsightType!
    private let searchingViewModel = SearchingViewModel()
    private let insights = BehaviorRelay<[Insight]>(value: [])
    private let disposeBag = DisposeBag()
    
    private let titleLabel = UILabel().then {
        $0.font = .pretenSemiBold(18)
        $0.textColor = .grayScale900
    }
    
    private let countLabel = UILabel().then {
        $0.font = .pretenSemiBold(16)
        $0.textColor = .grayScale900
    }
    
    private let chipView = HorizontalCollectionChipView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customBackButton.isHidden = false
        
        setupTableView()
        addSubViews()
        makeConstraints()
        configNavigationBarItem()
        
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 112
        tableView.separatorStyle = .none
        
        tableView.register(cell: InsightTableCell.self)
    }
    
    private func addSubViews() {
        view.addSubview(tableView)
        view.addSubview(chipView)
        view.addSubview(countLabel)
    }
    
    private func configNavigationBarItem() {
        leftNaviItemView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func makeConstraints() {
        chipView.snp.makeConstraints {
            $0.topEqualToNavigationBottom(vc: self).offset(24)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(36)
        }
        
        countLabel.snp.makeConstraints {
            if chipViewHidden {
                $0.topEqualToNavigationBottom(vc: self).offset(24)
            } else {
                $0.top.equalTo(chipView.snp.bottom).offset(16)
            }
            $0.leading.equalToSuperview().offset(20)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(countLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    func config(type: FullInsightType, totalPage: Int, title: String, insights: [Insight], myInsights: [Insight]? = nil, chipViewHidden: Bool = false) {
        insightType = type
        titleLabel.text = title
        countLabel.text = "\(insights.count)개"
        self.totalPage = totalPage
        self.insights.accept(insights)
        self.myInsights = myInsights
        self.chipViewHidden = chipViewHidden
        self.chipView.isHidden = chipViewHidden
    }
}

extension FullInsightViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return insights.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InsightTableCell", for: indexPath) as! InsightTableCell
        cell.selectionStyle = .none
        cell.configure(insight: insights.value[indexPath.row], layoutType: .horizontal)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchingViewModel.loadInsightDetail(id: insights.value[indexPath.row].insightId)
            .subscribe { [self] data in
                if let data = data {
                    let vc = InsightDetailViewController(url: "", insight: data, likeCount: insights.value[indexPath.row].likeCount, myInsights: myInsights)
                    vc.hidesBottomBarWhenPushed = true
                    navigationController?.pushViewController(vc, animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - scrollViewHeight - 100 { // 100px 여유
            switch insightType {
            case .my:
                loadMoreMyData()
            case .today:
                loadMoreTodayData()
            default:
                break
            }
        }
    }
    
    private func loadMoreTodayData() {
        guard !searchingViewModel.isLoading else { return }
        guard pageIndex < totalPage else { return }
        
        searchingViewModel.isLoading = true
        pageIndex += 1
            searchingViewModel.loadTodayInsights(page: pageIndex)
                .compactMap { $0 }
                .distinctUntilChanged()
                .subscribe(with: self, onNext: { owner, newData in
                    
                    var currentData = owner.insights.value
                    currentData.append(contentsOf: newData)
                    owner.insights.accept(currentData)
                    owner.countLabel.text = "\(owner.insights.value.count)개"
                    owner.tableView.reloadData()
                    owner.searchingViewModel.isLoading = false
                })
                .disposed(by: disposeBag)
    }
    
    private func loadMoreMyData() {
        guard !searchingViewModel.isLoading else { return }
        guard pageIndex < totalPage else { return }
        
        searchingViewModel.isLoading = true
        pageIndex += 1
        searchingViewModel.loadMyInsights(page: pageIndex)
                .compactMap { $0 }
                .distinctUntilChanged()
                .subscribe(with: self, onNext: { owner, newData in
                    
                    var currentData = owner.insights.value
                    currentData.append(contentsOf: newData)
                    owner.insights.accept(currentData)
                    owner.countLabel.text = "\(owner.insights.value.count)개"
                    owner.tableView.reloadData()
                    owner.searchingViewModel.isLoading = false
                })
                .disposed(by: disposeBag)
    }
}
