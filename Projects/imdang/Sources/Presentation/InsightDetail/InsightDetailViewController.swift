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

enum DetailExchangeState {
    case beforeRequest
    case afterRequest
    case waiting
    case done
}

final class InsightDetailViewController: BaseViewController {

    var testDate = InsightDetail.testData
    
    private var tableView: UITableView!
    private var insightImage = UIImage()
    private var exchangeState: DetailExchangeState
    
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
    private let buttonBackView = UIView().then { $0.backgroundColor = .white }
    
    init(image: UIImage, state: DetailExchangeState) {
        exchangeState = state
        insightImage = image
        testDate.profileImage = image
        super.init(nibName: nil, bundle: nil)
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
        
        view.addSubview(categoryTapView)
        categoryTapView.snp.makeConstraints {
            $0.topEqualToNavigationBottom(vc: self)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(44)
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
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    private func addSubviews() {
        view.addSubview(buttonBackView)
        switch exchangeState {
        case .beforeRequest:
            view.addSubview(requestButton)
        case .afterRequest:
            view.addSubview(degreeButton)
            view.addSubview(agreeButton)
        case .waiting:
            view.addSubview(waitButton)
        case .done:
            view.addSubview(doneButton)
        }
    }
    
    private func makeConstraints() {
        buttonBackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(96)
            $0.bottom.equalToSuperview()
        }
        switch exchangeState {
        case .beforeRequest:
            requestButton.snp.makeConstraints {
                $0.horizontalEdges.equalToSuperview().inset(20)
                $0.height.equalTo(56)
                $0.bottom.equalToSuperview().offset(-40)
            }
        case .afterRequest:
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
        case .waiting:
            waitButton.snp.makeConstraints {
                $0.horizontalEdges.equalToSuperview().inset(20)
                $0.height.equalTo(56)
                $0.bottom.equalToSuperview().offset(-40)
            }
        case .done:
            doneButton.snp.makeConstraints {
                $0.horizontalEdges.equalToSuperview().inset(20)
                $0.height.equalTo(56)
                $0.bottom.equalToSuperview().offset(-40)
            }
        }
    }
}

extension InsightDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return exchangeState == .done ? 7 : 3
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
            cell.config(image: insightImage)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath, cellType: InsightDetailTitleTableCell.self)
            cell.config(info: testDate)
            cell.selectionStyle = .none
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath, cellType: InsightDetailDefaultInfoTableCell.self)
            cell.config(info: testDate, state: exchangeState)
            cell.selectionStyle = .none
            return cell
        case 3:
            etcCell.config(info: testDate.infra.conversionArray(), text: testDate.infra.text)
            return etcCell
        case 4:
            etcCell.config(info: testDate.environment.conversionArray(), text: testDate.environment.text)
            return etcCell
        case 5:
            etcCell.config(info: testDate.facility.conversionArray(), text: testDate.facility.text)
            return etcCell
        case 6:
            etcCell.config(info: testDate.goodNews.conversionArray(), text: testDate.goodNews.text)
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
            footerView.config(text: testDate.infra.text)
            return footerView
        case 4:
            footerView.config(text: testDate.environment.text)
            return footerView
        case 5:
            footerView.config(text: testDate.facility.text)
            return footerView
        case 6:
            footerView.config(text: testDate.goodNews.text)
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
