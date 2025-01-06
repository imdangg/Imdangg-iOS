//
//  WriteInsightEtcViewController.swift
//  imdang
//
//  Created by 임대진 on 12/30/24.
//

import UIKit
enum ItemSelectType {
    case one, several
}
class WriteInsightEtcViewController: UIViewController {
    private let insightInfo: [InsightSectionInfo]
    private let tabTitle: String!
    private var totalAppraisalText: String = ""
    private var sectionItemClicked: [Bool] = []
    private var selectedButtonIndexInSection: [Int: Int] = [:]
    private var collectionView: UICollectionView!
    private var selectType: ItemSelectType
    
    init(info: [InsightSectionInfo], title: String, selectType: ItemSelectType) {
        self.insightInfo = info
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
        
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func reloadSectionItems(section: Int) {
        let indexPaths = (0..<collectionView.numberOfItems(inSection: section)).map {
            IndexPath(item: $0, section: section)
        }

        collectionView.reloadItems(at: indexPaths)
    }
}

extension WriteInsightEtcViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return insightInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return insightInfo[section].buttonTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedButtonIndexInSection[indexPath.section] = indexPath.row
        sectionItemClicked[indexPath.section] = true
        
//        collectionView.reloadSections(IndexSet(integer: indexPath.section))
//        reloadSectionItems(section: indexPath.section)
        
        for visibleIndexPath in collectionView.indexPathsForVisibleItems {
                guard let cell = collectionView.cellForItem(at: visibleIndexPath) as? InsightEtcCollectionCell else { continue }

                if selectType == .one {
                    if visibleIndexPath.section == indexPath.section {
                        if visibleIndexPath.row == indexPath.row {
                            cell.isSeleted()
                        } else {
                            cell.unSeleted()
                        }
                    }
                } else {
                    if visibleIndexPath.section == indexPath.section {
                        if visibleIndexPath.row == indexPath.row {
                            cell.isSeleted()
                            
                            let selectedText = cell.label.text ?? ""
                            if selectedText == "해당 없음" || selectedText ==  "잘 모르겠어요" {
                                // X 인 경우 다른 셀의 상태 해제
                                for otherVisibleIndexPath in collectionView.indexPathsForVisibleItems {
                                    if otherVisibleIndexPath.section == indexPath.section,
                                       otherVisibleIndexPath != visibleIndexPath {
                                        if let otherCell = collectionView.cellForItem(at: otherVisibleIndexPath) as? InsightEtcCollectionCell {
                                            otherCell.unSeleted()
                                        }
                                    }
                                }
                            } else {
                                // X 가 아닌 경우 X인 셀의 상태 해제
                                for otherVisibleIndexPath in collectionView.indexPathsForVisibleItems {
                                    if otherVisibleIndexPath.section == indexPath.section,
                                       otherVisibleIndexPath != visibleIndexPath {
                                        if let otherCell = collectionView.cellForItem(at: otherVisibleIndexPath) as? InsightEtcCollectionCell,
                                           otherCell.label.text == "해당 없음" || otherCell.label.text == "잘 모르겠어요" {
                                            otherCell.unSeleted()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        
        if let header = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: indexPath.section)) as? InsightEtcHeaderView {
            header.addCheckIcon()
        }
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionInfo = insightInfo[indexPath.section]
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath, cellType: InsightEtcCollectionCell.self)
        
        let buttonTitle = sectionInfo.buttonTitles[indexPath.row]
        cell.config(buttonTitle: buttonTitle)
        
        if selectedButtonIndexInSection[indexPath.section] == indexPath.row {
            cell.isSeleted()
        } else {
            cell.unSeleted()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableHeader(forIndexPath: indexPath, headerType: InsightEtcHeaderView.self)
            let sectionInfo = insightInfo[indexPath.section]
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
        return CGSize(width: collectionView.bounds.width, height: insightInfo[section].subTitle == nil ? 44 : 84)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == insightInfo.count - 1 {
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
            let lastSection = self.insightInfo.count - 1
            let footerIndexPath = IndexPath(item: 0, section: lastSection)
            self.collectionView.reloadSections(IndexSet(integer: footerIndexPath.section))
        }
        navigationController?.pushViewController(childVC, animated: true)
    }
}
