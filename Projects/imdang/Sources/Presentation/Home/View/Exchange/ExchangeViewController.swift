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

class ExchangeViewController: UIViewController, View {
   
    private let insights = BehaviorSubject<[Insight]>(value: [])
    var disposeBag = DisposeBag()
    
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
    private let noticeScriptView = NoticeScriptView().then {
        $0.configure(text: "교환한 인사이트는 보관함에 저장되며, 완료 내역은\n최근 7일간의 기록만 표시돼요.")
    }
    
    private let tableView = UITableView().then {
        $0.separatorStyle = .none
        $0.rowHeight = UITableView.automaticDimension
        $0.rowHeight = 100
       
    
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
        
        setupHeaderView()
        setupTableView()
        setupItems()
        
        let currentInsights = try? insights.value()
        updateButtonTitle(state: .waiting, num: currentInsights?.count ?? 0)
    }
    
    // MARK: - Setup Header View
    private func setupHeaderView() {
        let headerView = UIView()
        
        headerView.addSubview(ticketView)
        headerView.addSubview(segmentControl)
        headerView.addSubview(underLineView)
        headerView.addSubview(divideLineView)
        headerView.addSubview(exchangeStateButtonView)
        headerView.addSubview(noticeScriptView)
        
        ticketView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
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
            height: noticeScriptView.frame.maxY + 40
        )
        tableView.separatorInset = UIEdgeInsets(top: 4, left: 20, bottom: 4, right: 20)
        tableView.tableHeaderView = headerView
    }
    
    // MARK: - Setup Table View
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.register(InsightTableCell.self, forCellReuseIdentifier: "InsightTableCell")
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
       
    }
    

    func bind(reactor: ExchangeReactor) {
        insights
            .bind(to: tableView.rx.items(cellIdentifier: "InsightTableCell", cellType: InsightTableCell.self)) { _, insight, cell in
                cell.configure(insight: insight, layoutType: .horizontal)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self, let insight = try? self.insights.value()[indexPath.row] else { return }
                print("\(insight)")
                self.tableView.deselectRow(at: indexPath, animated: true)
            })
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
    
    @objc func segmentChanged() {
        let selectedIndex = segmentControl.selectedSegmentIndex
        UIView.animate(withDuration: 0.3) {
            let segmentWidth = self.segmentControl.bounds.width / CGFloat(self.segmentControl.numberOfSegments) + 1
            let centerXOffset = CGFloat(selectedIndex + 1) * segmentWidth + segmentWidth / 2
            
            self.underLineView.snp.updateConstraints {
                $0.centerX.equalTo(self.segmentControl.snp.leading).offset(centerXOffset - self.segmentControl.bounds.width / 2)
            }
            self.view.layoutIfNeeded()
        }
    }

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
}

extension ExchangeViewController {
    func setupItems(){
        let insights = (1...20).map { index in
            Insight(
                id: index,
                titleName: "Insight \(index)",
                titleImageUrl: "https://s3-alpha-sig.figma.com/img/bfd4/929c/86aa0d3566cba94912f0b4d10410b9b2?Expires=1733702400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=jVznuLFIzwecr875Ecx3wk6BTv7gmC1~-b0UoCUkxJI8rSjqu-NfEArK9bTrf~soTgQ9P8Dw-SGQaoN-k1R4nUTC1mz8Svwhdw7nd8YWWVbLO3a7nmdUH3oLTVfR0uqwvjJbVKPb7Pf3KQzXOHBp1o0JLhOt0sTYBMt8B2p47EYJe0QKTNrlmJDSQgJQCEyudHAyBl9WhC5CLU3UYHgN1VC9Ao6DbMkJusxmT3INQ3w-gHrvlovCvbLsBNvMTVlq4H7hAFzxLhR8ySqJ2cNzP7v-LyB2AwWIC15vYjs7lhctVXclsngtwPcUCSkaT53ghxo-TfB8bhZznInDWcTg0w__",
                userName: "User \(index)",
                profileImageUrl: "",
                adress: "Address \(index)",
                likeCount: index * 5
            )
        }
        self.insights.onNext(insights)
    }
}

