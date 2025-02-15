//
//  HomeContainerViewController.swift
//  imdang
//
//  Created by 임대진 on 11/20/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Then

enum HomeTapState {
    case search, exchange
}

class HomeContainerViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    private let homeViewModel = HomeViewModel()
    private let serverService = ServerJoinService.shared
    
    private let couponService = CouponService.shared
    private let searchViewController = SearchingViewController()
    private let exchangeViewController = ExchangeViewController(reactor: ExchangeReactor())
    
    private let searchButton = UIButton().then {
        $0.setTitle("탐색", for: .normal)
        $0.setTitleColor(.grayScale900, for: .normal)
        $0.titleLabel?.font = .pretenBold(24)
    }
    
    private let exchangeButton = UIButton().then {
        $0.setTitle("교환소", for: .normal)
        $0.setTitleColor(.grayScale500, for: .normal)
        $0.titleLabel?.font = .pretenBold(24)
    }
    
    private let alramButton = UIButton().then {
        $0.setImage(ImdangImages.Image(resource: .alarm), for: .normal)
    }
    
    private let myPageButton = UIButton().then {
        $0.setImage(ImdangImages.Image(resource: .person), for: .normal)
    }
    
    private let searchView = UIView().then {
        $0.backgroundColor = .white
        $0.isHidden = false
    }
    
    private let exchangeView = UIView().then {
        $0.backgroundColor = .white
        $0.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeViewModel.loadMyNickname()
        
        addSubviews()
        configNavigationBarItem()
        makeConstraints()
        bindActions()
        presentTooltip()
        
        navigationViewBottomShadow.isHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        serverService.checkTokenExpired()
        presentModal()
        loadCoupon()
    }
    
    private func popReportAlert() {
//                showReportAlert(title: "신고가 5회 누적되었어요", description: "3일간 인사이트 교환이 불가능해요.\n문의 사항은 아래 메일로 남겨주세요.", highligshtText: "3일간", email: true, type: .confirmOnly)
//                showReportAlert(title: "신고가 15회 누적되었어요", description: "5일간 인사이트 교환이 불가능해요.\n문의 사항은 아래 메일로 남겨주세요.", highligshtText: "5일간", email: true, type: .confirmOnly)
//                showReportAlert(title: "신고가 30회 누적되었어요", description: "7일간 인사이트 교환이 불가능해요.\n문의 사항은 아래 메일로 남겨주세요.", highligshtText: "7일간", email: true, type: .confirmOnly)
//                showReportAlert(title: "신고가 50회 누적되었어요", description: "해당 계정은 서비스를 사용할 수 없어요.\n문의 사항은 아래 메일로 남겨주세요.", highligshtText: "서비스를 사용할 수 없어요.", email: true, type: .confirmOnly)
    }
    
    private func loadCoupon() {
        couponService.getCoupons()
            .subscribe { result in
                UserdefaultKey.couponCount = result.couponCount
            }.disposed(by: disposeBag)
    }
    
    private func presentModal() {
        if !UserdefaultKey.couponReceived {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            let todayString = formatter.string(from: Date())
            let savedDate = UserdefaultKey.dontSeeToday
            
            if todayString != savedDate {
                let modalVC = TicketModalViewController()
                modalVC.modalPresentationStyle = .overFullScreen
                modalVC.modalTransitionStyle = .crossDissolve
                self.present(modalVC, animated: true, completion: nil)
            }
        }
    }
                
    private func presentTooltip() {
        if !UserdefaultKey.homeToolTip {
            let toolTipView = ToolTipView(type: .up)
            view.addSubview(toolTipView)
            toolTipView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }
    
    private func addSubviews() {
        [searchView, exchangeView].forEach { view.addSubview($0) }
        
        addChild(searchViewController)
        addChild(exchangeViewController)
        
        searchView.addSubview(searchViewController.view)
        exchangeView.addSubview(exchangeViewController.view)
        
        searchViewController.didMove(toParent: self)
        exchangeViewController.didMove(toParent: self)
    }
    
    private func makeConstraints() {
        
        searchView.snp.makeConstraints {
            $0.top.equalTo(myPageButton.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        exchangeView.snp.makeConstraints {
            $0.topEqualToNavigationBottom(vc: self)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        searchViewController.view.snp.makeConstraints {
            $0.edges.equalTo(searchView)
        }
        
        exchangeViewController.view.snp.makeConstraints {
            $0.edges.equalTo(exchangeView)
        }
    }
    
    private func configNavigationBarItem() {
        [searchButton, exchangeButton].forEach {
            leftNaviItemView.addSubview($0)
        }
        [alramButton, myPageButton].forEach {
            rightNaviItemView.addSubview($0)
        }
        
        searchButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(34)
        }

        exchangeButton.snp.makeConstraints {
            $0.leading.equalTo(searchButton.snp.trailing).offset(24)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(34)
        }
        
        myPageButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(40)
        }

        alramButton.snp.makeConstraints {
            $0.trailing.equalTo(myPageButton.snp.leading).offset(-16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
    }
    
    private func bindActions() {
        searchButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.changeView(showView: .search)
            })
            .disposed(by: disposeBag)
        
        exchangeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.changeView(showView: .exchange)
            })
            .disposed(by: disposeBag)
        
        myPageButton.rx.tap
            .subscribe(onNext: { [weak self] state in
                let vc = MyPageViewController(reactor: MyPageReactor())
                vc.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(vc, animated: true)
        })
        .disposed(by: disposeBag)
        
        alramButton.rx.tap
            .subscribe(onNext: { [weak self] state in
                let vc = NotificationViewController(reactor: NotificationReactor())
                vc.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(vc, animated: true)
        })
        .disposed(by: disposeBag)
    }
    
    func changeView(showView: HomeTapState) {
        switch showView {
        case .search:
            searchView.isHidden = false
            exchangeView.isHidden = true
            exchangeButton.setTitleColor(.grayScale500, for: .normal)
            searchButton.setTitleColor(.grayScale900, for: .normal)
        case .exchange:
            searchView.isHidden = true
            exchangeView.isHidden = false
            searchButton.setTitleColor(.grayScale500, for: .normal)
            exchangeButton.setTitleColor(.grayScale900, for: .normal)
        }
    }
}
