//
//  Exchange.swift
//  imdang
//
//  Created by daye on 12/8/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import ReactorKit

enum ExchangeRequestState {
    case request
    case receive
}

final class ExchangeViewController: BaseViewController, View {
   
    private let insights = BehaviorSubject<[Insight]>(value: [])
    var disposeBag = DisposeBag()
//    
//    private let navigationLineView = UIView().then {
//        $0.backgroundColor = .grayScale100
//    }
    private let ticketView = TicketView()
    private let segmentControl = UISegmentedControl().then {
        $0.insertSegment(withTitle: "내가 요청한 내역", at: 0, animated: true)
        $0.insertSegment(withTitle: "내가 요청받은 내역", at: 1, animated: true)
        $0.selectedSegmentIndex = 0
        $0.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.grayScale500,
            NSAttributedString.Key.font: UIFont.pretenSemiBold(16)
        ], for: .normal)
        $0.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.grayScale900,
            NSAttributedString.Key.font: UIFont.pretenSemiBold(16)
        ], for: .selected)
        
        $0.selectedSegmentTintColor = .clear
        $0.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        $0.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        $0.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
    
    private let underLineView = UIView().then {
        $0.backgroundColor = .grayScale900
    }
    
    private let divideLineView = UIView().then {
        $0.backgroundColor = .grayScale100
    }
    
    private let exchangeStateButtonView = ExchangeStateButtonView()
    private let noticeScriptView = NoticeScriptView()
    
    private let tableView = UITableView().then {
        $0.separatorStyle = .none
        $0.rowHeight = UITableView.automaticDimension
        $0.rowHeight = 112
    }
    
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
        navigationViewBottomShadow.isHidden = false
        
        setupHeaderView()
        setupView()
        setupItems()
        
        let currentInsights = try? insights.value()
        updateButtonTitle(state: .waiting, num: currentInsights?.count ?? 0)
    }
    
    // MARK: - Setup Header View
    private func setupHeaderView() {
        let headerView = UIView()
        
        let subviews = [ticketView, segmentControl, underLineView, divideLineView, exchangeStateButtonView, noticeScriptView]
        subviews.forEach { headerView.addSubview($0) }
        
        ticketView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        segmentControl.snp.makeConstraints {
            $0.top.equalTo(ticketView.snp.bottom).offset(28)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(15)
        }
        
        underLineView.snp.makeConstraints {
            $0.top.equalTo(segmentControl.snp.bottom).offset(21)
            $0.width.equalTo(155)
            $0.height.equalTo(2)
            $0.centerX.equalTo(segmentControl.snp.leading).offset(97.5) // width/2 + 패딩20
        }
        
        divideLineView.snp.makeConstraints {
            $0.top.equalTo(underLineView.snp.bottom)
            $0.width.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        exchangeStateButtonView.snp.makeConstraints {
            $0.top.equalTo(divideLineView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        noticeScriptView.snp.makeConstraints {
            $0.top.equalTo(exchangeStateButtonView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        headerView.layoutIfNeeded()
        headerView.frame = CGRect(
            x: 0,
            y: 0,
            width: view.frame.width,
            height: noticeScriptView.frame.maxY + 20
        )
        
        tableView.tableHeaderView = headerView
    }
    
    // MARK: - Setup View
    private func setupView() {
//        view.addSubview(navigationLineView)
        view.addSubview(tableView)
        tableView.register(InsightTableCell.self, forCellReuseIdentifier: "InsightTableCell")
        
        //        navigationLineView.snp.makeConstraints {
        //            $0.top.equalToSuperview().inset(16)
        //            $0.height.equalTo(1)
        //            $0.horizontalEdges.equalToSuperview()
        //        }

        tableView.snp.makeConstraints {
            //            $0.top.equalTo(navigationLineView.snp.bottom)
            $0.topEqualToNavigationBottom(vc: self)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Bind
    func bind(reactor: ExchangeReactor) {
        
        insights.bind(to: tableView.rx.items) { (tableView, row, insight) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "InsightTableCell") as? InsightTableCell ?? InsightTableCell(style: .default, reuseIdentifier: "InsightTableCell")

            cell.configure(insight: insight, layoutType: .horizontal)
        
            cell.contentView.subviews.forEach { subview in
                if let insightCellView = subview as? InsightCellView {
                    insightCellView.snp.remakeConstraints {
                        $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 6, left: 20, bottom: 6, right: 20))
                    }
                }
            }
            return cell
        }
        .disposed(by: disposeBag)

        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self, let insight = try? self.insights.value()[indexPath.row] else { return }
                print("\(insight)")
                self.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
        
        segmentControl.rx.selectedSegmentIndex
            .map{ index in Reactor.Action.selectedRequestSegmentControl(index == 0 ? ExchangeRequestState.request : ExchangeRequestState.receive)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        exchangeStateButtonView.waitingButton.rx.tap
            .map{ Reactor.Action.tapExchangeStateButton(.waiting)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        exchangeStateButtonView.rejectButton.rx.tap
            .map{ Reactor.Action.tapExchangeStateButton(.reject)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        exchangeStateButtonView.doneButton.rx.tap
            .map{ Reactor.Action.tapExchangeStateButton(.done)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    
        reactor.state
            .map { $0.selectedExchangeState }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] state in
                guard let self = self else { return }
                
                exchangeStateButtonView.waitingButton.rx.commonButtonState.onNext(state == .waiting ? .enabled : .unselectedBorderStyle)
                exchangeStateButtonView.rejectButton.rx.commonButtonState.onNext(state == .reject ? .enabled : .unselectedBorderStyle)
                exchangeStateButtonView.doneButton.rx.commonButtonState.onNext(state == .done ? .enabled : .unselectedBorderStyle)
                
                let currentInsights = try? insights.value()
                let count = currentInsights?.count ?? 0
                
                updateScript(state: state, num: count)
                updateButtonTitle(state: state, num: count)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - update view
    
    private func updateButtonTitle(state: ExchangeState, num: Int) {
        switch state {
        case .waiting:
            exchangeStateButtonView.waitingButton.setButtonTitle(title: "\(ExchangeState.waiting.rawValue)(\(num))")
            exchangeStateButtonView.rejectButton.setButtonTitle(title: "\(ExchangeState.reject.rawValue)")
            exchangeStateButtonView.doneButton.setButtonTitle(title: "\(ExchangeState.done.rawValue)")
        case .reject:
            exchangeStateButtonView.waitingButton.setButtonTitle(title: "\(ExchangeState.waiting.rawValue)")
            exchangeStateButtonView.rejectButton.setButtonTitle(title: "\(ExchangeState.reject.rawValue)(\(num))")
            exchangeStateButtonView.doneButton.setButtonTitle(title: "\(ExchangeState.done.rawValue)")
        case .done:
            exchangeStateButtonView.waitingButton.setButtonTitle(title: "\(ExchangeState.waiting.rawValue)")
            exchangeStateButtonView.rejectButton.setButtonTitle(title: "\(ExchangeState.reject.rawValue)")
            exchangeStateButtonView.doneButton.setButtonTitle(title: "\(ExchangeState.done.rawValue)(\(num))")
        }
    }
    
    private func updateScript(state: ExchangeState, num: Int) {
        if num < 1 {
            switch state {
            case .waiting:
                noticeScriptView.configure(text: "대기 중인 내역이 없어요.")
            case .reject:
                noticeScriptView.configure(text: "거절 내역이 없어요.")
            case .done:
                noticeScriptView.configure(text: "교환 완료 내역이 없어요.")
            }
        } else  {
            switch state {
            case .waiting:
                noticeScriptView.configure(text: "대기 중 내역은 최근 7일간의 기록만 표시돼요.")
            case .reject:
                noticeScriptView.configure(text: "거절 내역은 최근 7일간의 기록만 표시돼요")
            case .done:
                noticeScriptView.configure(text: "교환한 인사이트는 보관함에 저장되며, 완료 내역은\n최근 7일간의 기록만 표시돼요.")
                
            }
        }
    }
    
    @objc func segmentChanged() {
        let selectedIndex = segmentControl.selectedSegmentIndex
        UIView.animate(withDuration: 0.2) {
            let segmentWidth = self.segmentControl.bounds.width / CGFloat(self.segmentControl.numberOfSegments) + 1
            let centerXOffset = CGFloat(selectedIndex + 1) * segmentWidth + segmentWidth / 2
            
            self.underLineView.snp.updateConstraints {
                $0.centerX.equalTo(self.segmentControl.snp.leading).offset(centerXOffset - self.segmentControl.bounds.width / 2)
            }
            self.view.layoutIfNeeded()
        }
    }
}

extension ExchangeViewController {
    func setupItems(){
        let insights = (1...20).map { index in
            Insight(
                id: index,
                titleName: "Insight \(index)",
                titleImageUrl: "https://img1.newsis.com/2023/07/12/NISI20230712_0001313626_web.jpg",
                userName: "User \(index)",
                profileImageUrl: "",
                adress: "Address \(index)",
                likeCount: index * 5
            )
        }
        self.insights.onNext(insights)
    }
}

