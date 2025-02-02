////
////  InsightDetailViewController.swift
////  imdang
////
////  Created by 임대진 on 1/8/25.
////
//
import UIKit
import SnapKit
import Then
import RxSwift
final class InsightDetailViewController: BaseViewController {

    private var insight: InsightDetail!
    private var mainImage: UIImage?
    private var tableView: UITableView!
    private var insightImageUrl = ""
    private var likeCount: Int
    private var exchangeState: DetailExchangeState
    private var disposeBag = DisposeBag()
    private let myInsights: [Insight]?
    private let insightDetailViewModel = InsightDetailViewModel()
    
    private let categoryTapView = InsightDetailCategoryTapView().then {
        $0.isHidden = true
    }
    
    private let reportIcon = UIImageView().then {
        $0.image = ImdangImages.Image(resource: .report)
    }
    
    private let shareIcon = UIImageView().then {
        $0.image = ImdangImages.Image(resource: .share)
    }
    
    private let requestButton = CommonButton(title: "교환 요청", initialButtonType: .enabled)
    private let degreeButton = CommonButton(title: "거절", initialButtonType: .whiteBackBorderStyle)
    private let agreeButton = CommonButton(title: "수락", initialButtonType: .enabled)
    private let waitButton = CommonButton(title: "대기중", initialButtonType: .disabled)
    private let doneButton = CommonButton(title: "교환 완료", initialButtonType: .disabled)
    private let buttonBackView = UIView().then { $0.backgroundColor = .white }.then { $0.applyTopBlur() }
    
    init(url: String, image: UIImage? = nil, insight: InsightDetail, likeCount: Int, myInsights: [Insight]? = nil) {
        exchangeState = insight.exchangeRequestStatus
        insightImageUrl = url
        mainImage = image
        self.likeCount = likeCount
        self.myInsights = myInsights
        self.insight = insight
        
        super.init(nibName: nil, bundle: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleModalDismiss), name: .detailModalDidDismiss, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .detailModalDidDismiss, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customBackButton.isHidden = false
        navigationViewBottomShadow.isHidden = true
        
        setNavigationItem()
        configureTableView()
        addSubviews()
        makeConstraints()
        bindActions()
        
        view.addSubview(categoryTapView)
        categoryTapView.snp.makeConstraints {
            $0.topEqualToNavigationBottom(vc: self)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(44)
        }
    }
    
    
    @objc private func handleModalDismiss() {
        self.navigationController?.popToRootViewController(animated: true)
        self.navigationController?.viewControllers.forEach {
            if let homeVC = $0 as? HomeContainerViewController {
                homeVC.changeView(showView: .exchange)
            }
        }
    }
    private func setNavigationItem() {
        [reportIcon, shareIcon].forEach { rightNaviItemView.addSubview($0) }
        
        shareIcon.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(10)
        }
        
        reportIcon.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(shareIcon.snp.leading).offset(-12)
        }
    }
    
    private func configureTableView() {
        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 1
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        
        tableView.register(cell: UITableViewCell.self)
        tableView.register(cell: InsightDetailImageCell.self)
        tableView.register(cell: InsightDetailEtcTableCell.self)
        tableView.register(cell: InsightDetailTitleTableCell.self)
        tableView.register(cell: InsightDetailDefaultInfoTableCell.self)
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.topEqualToNavigationBottom(vc: self)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-96)
        }
    }
    
    private func addSubviews() {
        [buttonBackView, requestButton, waitButton, doneButton, degreeButton, agreeButton].forEach {
            view.addSubview($0)
        }
    }
    
    private func makeConstraints() {
        buttonBackView.snp.makeConstraints() {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(96)
            $0.bottom.equalToSuperview()
        }
        
        [requestButton, waitButton, doneButton].forEach {
            $0.snp.makeConstraints {
                $0.horizontalEdges.equalToSuperview().inset(20)
                $0.height.equalTo(56)
                $0.bottom.equalToSuperview().offset(-40)
            }
        }
        
        degreeButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalTo(buttonBackView.snp.centerX).offset(-5)
            $0.height.equalTo(56)
            $0.bottom.equalToSuperview().offset(-40)
        }
        
        agreeButton.snp.makeConstraints {
            $0.leading.equalTo(buttonBackView.snp.centerX).offset(5)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(56)
            $0.bottom.equalToSuperview().offset(-40)
        }
        
        updateButton()
    }
    
    private func updateButton() {
        [requestButton, waitButton, doneButton, degreeButton, agreeButton].forEach {
            $0.isHidden = true
        }
        
        switch exchangeState {
        case .null:
            if myInsights != nil  {
                requestButton.isHidden = false
            } else {
                buttonBackView.isHidden = true
                tableView.snp.updateConstraints {
                    $0.bottom.equalToSuperview()
                }
            }
        case .pending:
            if let state = insight.exchangeRequestCreatedByMe {
                if state {
                    waitButton.isHidden = false
                } else {
                    degreeButton.isHidden = false
                    agreeButton.isHidden = false
                }
            } else {
                waitButton.isHidden = false
            }
        case .rejected:
            if let state = insight.exchangeRequestCreatedByMe {
                if state {
                    buttonBackView.isHidden = true
                    tableView.snp.updateConstraints {
                        $0.bottom.equalToSuperview()
                    }
                } else {
                    degreeButton.isHidden = false
                    agreeButton.isHidden = false
                }
            }
        case .accepted:
            if let state = insight.exchangeRequestCreatedByMe {
                if state {
                    buttonBackView.isHidden = true
                    tableView.snp.updateConstraints {
                        $0.bottom.equalToSuperview()
                    }
                } else {
                    doneButton.isHidden = false
                }
            } else {
                doneButton.isHidden = false
            }
        }
    }
    
    private func bindActions() {
        requestButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                
                if let insights = owner.myInsights {
                    let vc = MyInsightsModalViewController(insightId: owner.insight.insightId, myInsights: insights)
                    
                    vc.resultSend = {
                        if $0 {
                            owner.exchangeState = .pending
                            owner.updateButton()
                            owner.tableView.reloadData()
                        }
                    }
                    
                    vc.modalPresentationStyle = .pageSheet
                    vc.modalTransitionStyle = .coverVertical
                    self.present(vc, animated: true, completion: nil)
                } else {
                    owner.showAlert(text: "교환할 인사이트가 없어요.\n임장을 다녀온 후 인사이트를\n작성해주세요.", type: .confirmOnly, imageType: .circleCheck)
                }
            })
            .disposed(by: disposeBag)
        
        agreeButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.insightDetailViewModel.acceptInsight(exchangeRequestId: owner.insight.exchangeRequestId ?? "")
                    .subscribe(onNext: {
                        if $0 {
                            owner.showAlert(text: "교환을 수락했어요.\n교환한 인사이트는 보관함에서\n확인할 수 있어요.", type: .moveButton, imageType: .circleCheck) {
                                owner.exchangeState = .accepted
                                owner.updateButton()
                                owner.tableView.reloadData()
                            } etcAction: {
                                self.dismiss(animated: true)
                                self.navigationController?.popToRootViewController(animated: true)
                                guard let tabBarController = self.tabBarController else { return }
                                UIView.animate(withDuration: 5) {
                                    tabBarController.selectedIndex = 2
                                }
                            }
                        }
                    })
                    .disposed(by: owner.disposeBag)
            })
            .disposed(by: disposeBag)
        
        degreeButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.insightDetailViewModel.rejecttInsight(exchangeRequestId: owner.insight.exchangeRequestId ?? "")
                    .subscribe(onNext: {
                        if $0 {
                            owner.showAlert(text: "교환을 거절했어요.", type: .confirmOnly, imageType: .circleCheck)
                            owner.navigationController?.popViewController(animated: true)
                        }
                    })
                    .disposed(by: owner.disposeBag)
            })
            .disposed(by: disposeBag)
    }
}

extension InsightDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return exchangeState == .null ? myInsights == nil ? 7 : 3 : exchangeState == .accepted ? 7 : 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let etcCell = tableView.dequeueReusableCell(forIndexPath: indexPath, cellType: InsightDetailEtcTableCell.self)
        etcCell.selectionStyle = .none
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath, cellType: InsightDetailImageCell.self)
            cell.config(url: insightImageUrl, image: mainImage)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath, cellType: InsightDetailTitleTableCell.self)
            cell.config(info: insight, likeCount: likeCount)
            cell.selectionStyle = .none
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath, cellType: InsightDetailDefaultInfoTableCell.self)
            cell.config(info: insight, state: exchangeState, isMyInsight: myInsights == nil)
            cell.selectionStyle = .none
            return cell
        case 3:
            etcCell.config(info: insight.infra.conversionArray(), text: insight.infra.text)
            return etcCell
        case 4:
            etcCell.config(info: insight.complexEnvironment.conversionArray(), text: insight.complexEnvironment.text)
            return etcCell
        case 5:
            etcCell.config(info: insight.complexFacility.conversionArray(), text: insight.complexFacility.text)
            return etcCell
        case 6:
            etcCell.config(info: insight.favorableNews.conversionArray(), text: insight.favorableNews.text)
            return etcCell
        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 2:
            return 44
        case 3,4,5,6:
            return 32
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = InsightDetailCategoryTapView()
        switch section {
        case 2:
            return headerView
        default:
            return UIView().then { $0.backgroundColor = .white }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0,1,2:
            return 0
        default:
            return UITableView.automaticDimension
        }
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = InsightDetailEtcFooterView()
        switch section {
        case 3:
            footerView.config(text: insight.infra.text)
            return footerView
        case 4:
            footerView.config(text: insight.complexEnvironment.text)
            return footerView
        case 5:
            footerView.config(text: insight.complexFacility.text)
            return footerView
        case 6:
            footerView.config(text: insight.favorableNews.text)
            footerView.separatorView.isHidden = true
            return footerView
        default:
            return nil
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let headerHeight: CGFloat = 423
        let sectionHeaderYOffset = scrollView.contentOffset.y
        
        if sectionHeaderYOffset >= headerHeight {
            categoryTapView.isHidden = false
        } else {
            categoryTapView.isHidden = true
        }
    }
}
