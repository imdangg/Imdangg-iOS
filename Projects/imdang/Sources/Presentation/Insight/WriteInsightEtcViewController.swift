//
//  WriteInsightEtcViewController.swift
//  imdang
//
//  Created by 임대진 on 12/30/24.
//

import UIKit
import RxSwift
import RxRelay
import ReactorKit

enum ItemSelectType {
    case one, several
}

class WriteInsightEtcViewController: UIViewController, View {
    
    var disposeBag = DisposeBag()
    
    private let insightSectionInfo: [InsightSectionInfo]
    private let tabTitle: String!
    private var baseInfo = InsightDetail.emptyInsight
    private var totalAppraisalText: String = ""
    private var sectionItemClicked: [Bool] = []
    private var selectedButtonIndexInSection: [Int: Int] = [:]
    private var collectionView: UICollectionView!
    private var selectType: ItemSelectType
    private var nextButtonView = NextAndBackButton(needBack: true)
    private var checkSectionState = PublishRelay<Set<Int>>()
    private var selectedSections: Set<Int> = []
    
    init(info: [InsightSectionInfo], title: String, selectType: ItemSelectType) {
        self.insightSectionInfo = info
        self.tabTitle = title
        self.selectType = selectType
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        sectionItemClicked = Array(repeating: false, count: collectionView.numberOfSections)
    }
    
    private func setupCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 8
        flowLayout.minimumInteritemSpacing = 8
        flowLayout.sectionInset = UIEdgeInsets(top: 8, left: 20, bottom: 16, right: 20)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .grayScale25
        
        collectionView.register(header: InsightEtcHeaderView.self)
        collectionView.register(cell: InsightEtcCollectionCell.self)
        collectionView.register(footer: InsightTotalAppraisalFooterView.self)
        
        view.addSubview(collectionView)
        view.addSubview(nextButtonView)
        
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        nextButtonView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(96)
        }
    }
    
    private func reloadSectionItems(section: Int) {
        let indexPaths = (0..<collectionView.numberOfItems(inSection: section)).map {
            IndexPath(item: $0, section: section)
        }
        
        collectionView.reloadItems(at: indexPaths)
    }
    
    private func cellRedundancyAndUnselectProcessing(_ collectionView: UICollectionView, indexPath: IndexPath) {
        for visibleIndexPath in collectionView.indexPathsForVisibleItems {
            guard let cell = collectionView.cellForItem(at: visibleIndexPath) as? InsightEtcCollectionCell else { continue }
            
            if selectType == .one {
                if visibleIndexPath.section == indexPath.section {
                    if visibleIndexPath.row == indexPath.row {
                        cell.isClicked = true
                    } else {
                        cell.isClicked = false
                    }
                }
            } else {
                if visibleIndexPath.section == indexPath.section {
                    if visibleIndexPath.row == indexPath.row {
                        
                        let selectedText = cell.label.text ?? ""
                        if selectedText == "해당 없음" || selectedText ==  "잘 모르겠어요" {
                            if cell.isClicked == false {
                                var otherCells: [InsightEtcCollectionCell] = []
                                
                                for otherVisibleIndexPath in collectionView.indexPathsForVisibleItems {
                                    if otherVisibleIndexPath.section == indexPath.section,
                                       otherVisibleIndexPath != visibleIndexPath {
                                        if let otherCell = collectionView.cellForItem(at: otherVisibleIndexPath) as? InsightEtcCollectionCell {
                                            otherCells.append(otherCell)
                                        }
                                    }
                                }
                                
                                // 클릭되어있는 셀 있을시 모달
                                if otherCells.filter({ $0.isClicked == true }).count > 0 {
                                    showInsightAlert {
                                        cell.isClicked = true
                                        for otherCell in otherCells {
                                            otherCell.isClicked = false
                                        }
                                    } cancelAction: {
                                        cell.isClicked = false
                                    }
                                } else {
                                    cell.isClicked = true
                                }
                                
                            } else {
                                cell.isClicked = false
                            }
                        } else {
                            cell.isClicked.toggle()
                            
                            // 해당없음 셀의 상태 해제
                            for otherVisibleIndexPath in collectionView.indexPathsForVisibleItems {
                                if otherVisibleIndexPath.section == indexPath.section,
                                   otherVisibleIndexPath != visibleIndexPath {
                                    if let otherCell = collectionView.cellForItem(at: otherVisibleIndexPath) as? InsightEtcCollectionCell,
                                       otherCell.label.text == "해당 없음" || otherCell.label.text == "잘 모르겠어요" {
                                        otherCell.isClicked = false
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func checkCellAllClear(_ collectionView: UICollectionView, indexPath: IndexPath) -> Bool {
        var result = false
        for row in 0..<collectionView.numberOfItems(inSection: indexPath.section) {
            let cellIndexPath = IndexPath(row: row, section: indexPath.section)
            if let cell = collectionView.cellForItem(at: cellIndexPath) as? InsightEtcCollectionCell {
                if cell.isClicked {
                    result = true
                    break
                }
            }
        }
        
        return result
    }
    
    private func headerCheckIconProcessing(isClear: Bool, _ collectionView: UICollectionView, indexPath: IndexPath) {
        if let header = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: indexPath.section)) as? InsightEtcHeaderView {
            if isClear {
                header.removeCheckIcon()
            } else {
                header.addCheckIcon()
            }
        }
    }
    
    private func setSectionState(isClear: Bool, index: Int) {
        if isClear {
            selectedSections.remove(index)
        } else {
            selectedSections.insert(index)
        }
        checkSectionState.accept(selectedSections)
    }
    
    func bind(reactor: InsightReactor) {
        if tabTitle == "인프라" {
            nextButtonView.nextButton.rx.tap
                .map { InsightReactor.Action.tapInfraInfoConfirm(self.baseInfo.infra) }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
            
        } else if tabTitle == "단지 환경" {
            nextButtonView.nextButton.rx.tap
                .map { InsightReactor.Action.tapEnvironmentInfoConfirm(self.baseInfo.complexEnvironment) }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
            
        } else if tabTitle == "단지 시설" {
            nextButtonView.nextButton.rx.tap
                .map { InsightReactor.Action.tapFacilityInfoConfirm(self.baseInfo.complexFacility) }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
            
        } else if tabTitle == "호재" {
            nextButtonView.nextButton.setTitle("작성완료 및 업로드", for: .normal)
            nextButtonView.makeConstraints(needBack: false)
            
            nextButtonView.nextButton.rx.tap
                .map { InsightReactor.Action.tapFavorableNewsInfoConfirm(self.baseInfo.favorableNews) }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
        }
        
        nextButtonView.backButton.rx.tap
            .map { InsightReactor.Action.tapBackButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        checkSectionState
            .subscribe(onNext: { [weak self] arr in
                guard let self = self else { return }
                self.nextButtonView.nextButtonEnable(value: arr.count == insightSectionInfo.count ? true : false)
            })
            .disposed(by: disposeBag)
    }
}

extension WriteInsightEtcViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return insightSectionInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return insightSectionInfo[section].buttonTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let isClear = checkCellAllClear(collectionView, indexPath: indexPath)
        selectedButtonIndexInSection[indexPath.section] = indexPath.row
        sectionItemClicked[indexPath.section] = true
        
        //        collectionView.reloadSections(IndexSet(integer: indexPath.section))
        //        reloadSectionItems(section: indexPath.section)
        cellRedundancyAndUnselectProcessing(collectionView, indexPath: indexPath)
        
        headerCheckIconProcessing(isClear: isClear, collectionView, indexPath: indexPath)
        setSectionState(isClear: isClear, index: indexPath.section)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionInfo = insightSectionInfo[indexPath.section]
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath, cellType: InsightEtcCollectionCell.self)
        
        let buttonTitle = sectionInfo.buttonTitles[indexPath.row]
        cell.config(buttonTitle: buttonTitle)
        
        if selectedButtonIndexInSection[indexPath.section] == indexPath.row {
            cell.isClicked = true
        } else {
            cell.isClicked = false
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableHeader(forIndexPath: indexPath, headerType: InsightEtcHeaderView.self)
            let sectionInfo = insightSectionInfo[indexPath.section]
            header.config(title: sectionInfo.title, description: sectionInfo.description, subtitle: sectionInfo.subTitle)
            
            if sectionItemClicked[indexPath.section] {
                header.addCheckIcon()
            } else {
                header.removeCheckIcon()
            }
            
            return header
        } else if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableFooter(forIndexPath: indexPath, footerType: InsightTotalAppraisalFooterView.self)
            footer.config(title: tabTitle + " 총평")
            footer.customTextView.text = totalAppraisalText
            footer.delegate = self
            
            return footer
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: insightSectionInfo[section].subTitle == nil ? 44 : 84)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == insightSectionInfo.count - 1 {
            return CGSize(width: collectionView.bounds.width, height: 300)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalPadding: CGFloat = 20 * 2
        let interItemSpacing: CGFloat = 8
        let totalSpacing = horizontalPadding + interItemSpacing
        
        let itemWidth = (collectionView.bounds.width - totalSpacing) / 2
        
        return CGSize(width: itemWidth, height: 52)
    }
}

extension WriteInsightEtcViewController: TotalAppraisalFootereViewDelegate {
    
    func didTapButton(title: String, text: String) {
        let childVC = CommonTextViewViewComtroller(title: title, text: text)
        
        childVC.onDataSend = { [weak self] data in
            guard let self = self else { return }
            
            self.totalAppraisalText = data
            let lastSection = self.insightSectionInfo.count - 1
            let footerIndexPath = IndexPath(item: 0, section: lastSection)
            self.collectionView.reloadSections(IndexSet(integer: footerIndexPath.section))
        }
        navigationController?.pushViewController(childVC, animated: true)
    }
}
