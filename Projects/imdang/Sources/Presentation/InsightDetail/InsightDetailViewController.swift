//
//  InsightDetailViewController.swift
//  imdang
//
//  Created by 임대진 on 1/8/25.
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
    private var collectionView: UICollectionView!
    
    private let insightEtcView = InsightDetailEtcCollectionCell()
    
    private let categoryTapView = InsightDetailCategoryTapView().then {
        $0.isHidden = true
    }
    
    private var exchangeState: DetailExchangeState
    
    private let reportIcon = UIImageView().then {
        $0.image = ImdangImages.Image(resource: .report)
    }
    
    private let shareIcon = UIImageView().then {
        $0.image = ImdangImages.Image(resource: .share)
    }
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    
    init(image: UIImage, state: DetailExchangeState) {
        exchangeState = state
        imageView.image = image
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
        configureCollectionView()
        
        
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
    
    private func configureCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
////        flowLayout.minimumLineSpacing = 8
////        flowLayout.minimumInteritemSpacing = 8
//
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPrefetchingEnabled = false // 셀 미리 로딩 비활성화
        
        collectionView.register(cell: UICollectionViewCell.self)
        collectionView.register(header: UICollectionReusableView.self)
        
        collectionView.register(cell: InsightDetailEtcCollectionCell.self)
        collectionView.register(cell: InsightDetailTitleCollectionCell.self)
        collectionView.register(cell: InsightDetailDefaultInfoCollectionCell.self)
        collectionView.register(header: InsightDetailCategoryTapViewCell.self)
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.topEqualToNavigationBottom(vc: self)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
}

extension InsightDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
                if kind == UICollectionView.elementKindSectionHeader {
                    if indexPath.section == 2 {
                        let headerView = collectionView.dequeueReusableHeader(forIndexPath: indexPath, headerType: InsightDetailCategoryTapViewCell.self)
                        return headerView
                    } else {
                        return UICollectionReusableView()
                    }
                } else {
                    return UICollectionReusableView()
                }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath, cellType: UICollectionViewCell.self)
            cell.contentView.addSubview(imageView)
            imageView.snp.makeConstraints {
                $0.edges.equalToSuperview()
                $0.width.equalTo(UIScreen.main.bounds.width)
                $0.height.equalTo(300)
            }
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath, cellType: InsightDetailTitleCollectionCell.self)
            cell.config(info: testDate)
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath, cellType: InsightDetailDefaultInfoCollectionCell.self)
            cell.config(info: testDate, state: .beforeRequest)
            return cell
        case 3:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath, cellType: InsightDetailEtcCollectionCell.self)
            cell.config(info: testDate.infra.conversionArray(), text: testDate.infra.text)
            cell.backgroundColor = .red
            return cell
        case 4:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath, cellType: InsightDetailEtcCollectionCell.self)
            cell.config(info: testDate.environment.conversionArray(), text: testDate.environment.text)
            cell.backgroundColor = .orange
            return cell
        case 5:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath, cellType: InsightDetailEtcCollectionCell.self)
            cell.config(info: testDate.facility.conversionArray(), text: testDate.facility.text)
            cell.backgroundColor = .yellow
            return cell
        case 6:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath, cellType: InsightDetailEtcCollectionCell.self)
            cell.config(info: testDate.goodNews.conversionArray(), text: testDate.goodNews.text)
            cell.backgroundColor = .green
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case 2, 3, 4, 5, 6:
            return UIEdgeInsets(top: 0, left: 0, bottom: 32, right: 0)
        default:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 2 {
            return CGSize(width: UIScreen.main.bounds.width, height: 44)
        }
        return .zero
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
