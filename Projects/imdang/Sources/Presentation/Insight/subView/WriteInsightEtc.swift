//
//  WriteInsightEtc.swift
//  imdang
//
//  Created by 임대진 on 12/30/24.
//

import UIKit

class WriteInsightEtc: UIViewController {
    let insightInfo: [InsightSectionInfo]
    private var collectionView: UICollectionView!
    
    init(info: [InsightSectionInfo]) {
        self.insightInfo = info
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
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
}

extension WriteInsightEtc: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return insightInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return insightInfo[section].buttonTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionInfo = insightInfo[indexPath.section]
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath, cellType: InsightEtcCollectionCell.self)
        
        let buttonTitle = sectionInfo.buttonTitles[indexPath.row]
        cell.config(buttonTitle: buttonTitle)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableHeader(forIndexPath: indexPath, headerType: InsightEtcHeaderView.self)
            let sectionInfo = insightInfo[indexPath.section]
            header.config(title: sectionInfo.title, description: sectionInfo.description, subtitle: sectionInfo.subTitle)
            return header
        } else if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableFooter(forIndexPath: indexPath, footerType: InsightTotalAppraisalFooterView.self)
            footer.config(title: "호재 총평")
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
