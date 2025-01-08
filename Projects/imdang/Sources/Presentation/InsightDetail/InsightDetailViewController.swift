//
//  InsightDetailViewController.swift
//  imdang
//
//  Created by 임대진 on 1/8/25.
//

import UIKit
import SnapKit
import Then

final class InsightDetailViewController: BaseViewController {
    var testDate = InsightDetail.testData
    private var collectionView: UICollectionView!
    private let insightDetailTitleView = InsightDetailTitleView()
    private let insightDetailBasicView = InsightDetailBasicView()
    
    private let reportIcon = UIImageView().then {
        $0.image = ImdangImages.Image(resource: .report)
    }
    
    private let shareIcon = UIImageView().then {
        $0.image = ImdangImages.Image(resource: .share)
    }
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    
    init(image: UIImage) {
        super.init(nibName: nil, bundle: nil)
        self.imageView.image = image
        testDate.profileImage = image
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
        
        insightDetailTitleView.config(info: testDate)
        insightDetailBasicView.config(info: testDate)
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
        let layout = createCompositionalLayout()
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.register(cell: UICollectionViewCell.self)
        collectionView.register(header: UICollectionReusableView.self)
        collectionView.register(footer: UICollectionReusableView.self)
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.topEqualToNavigationBottom(vc: self)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Compositional Layout
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0:
                return self.first()
            case 1:
                return self.second()
            case 2:
                return self.second2()
            default:
                return nil
            }
        }
    }
    
    private func first() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .absolute(310))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(310))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    private func second() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .absolute(123))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(123))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    private func second2() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 40, trailing: 0)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        header.pinToVisibleBounds = true
        
        let separatorSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(8))
        let separator = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: separatorSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        separator.contentInsets = NSDirectionalEdgeInsets(top: 32, leading: 0, bottom: 0, trailing: 0)
        
        section.boundarySupplementaryItems = [header, separator]
        
        return section
    }
    
    private func createHorizontalScrollSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .absolute(131))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(UIScreen.main.bounds.width - 40),
                                               heightDimension: .absolute(131))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.interGroupSpacing = 12
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(28))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        let separatorSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(8))
        let separator = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: separatorSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 0)
        separator.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: -20, bottom: 0, trailing: 0)
        header.contentInsets = NSDirectionalEdgeInsets(top: -32, leading: 0, bottom: 0, trailing: 20)
        
        section.orthogonalScrollingBehavior = .groupPaging
        section.visibleItemsInvalidationHandler = { [weak self] _, contentOffset, environment in
            let containerWidth = environment.container.contentSize.width
            let itemWidth = environment.container.contentSize.width
            let pageIndex = Int(max(0, round(contentOffset.x / itemWidth)))
        }
        
        section.boundarySupplementaryItems = [header, separator]
        return section
    }
    
    private func createStickyHeaderSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(112))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 0)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(122))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: -20, bottom: 0, trailing: 0)
        header.pinToVisibleBounds = true // 헤더 고정
        
        section.boundarySupplementaryItems = [header]
        return section
    }
    
}

extension InsightDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
                if kind == UICollectionView.elementKindSectionHeader {
        
                    switch indexPath.section {
                    case 2:
                        let headerView = collectionView.dequeueReusableHeader(forIndexPath: indexPath, headerType: UICollectionReusableView.self)
                        let view = InsightCategoryTapView()
                        headerView.addSubview(view)
                        view.snp.makeConstraints {
                            $0.top.equalToSuperview()
                            $0.horizontalEdges.equalToSuperview()
                            $0.height.equalTo(44)
                        }
                        
                        return headerView
                    default:
                        return UICollectionReusableView()
                    }
                } else {
                    switch indexPath.section {
                    case 2:
                        let footerView = collectionView.dequeueReusableFooter(forIndexPath: indexPath, footerType: UICollectionReusableView.self)
                        let view = SectionSeparatorView()
                        footerView.addSubview(view)
                        view.snp.makeConstraints {
                            $0.top.equalToSuperview()
                            $0.horizontalEdges.equalToSuperview()
                            $0.height.equalTo(8)
                        }
                        return footerView
                    default:
                        return UICollectionReusableView()
                    }
                }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath, cellType: UICollectionViewCell.self)
            cell.addSubview(imageView)
            imageView.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.horizontalEdges.equalToSuperview()
                $0.height.equalTo(310)
            }
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath, cellType: UICollectionViewCell.self)
            cell.addSubview(insightDetailTitleView)
            insightDetailTitleView.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.horizontalEdges.equalToSuperview()
                $0.height.equalTo(123)
            }
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath, cellType: UICollectionViewCell.self)
            cell.addSubview(insightDetailBasicView)
            insightDetailBasicView.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.horizontalEdges.equalToSuperview()
            }
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            
            return cell
        }
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let headerHeight: CGFloat = 220
//        let isScrolledPastHeader = scrollView.contentOffset.y >= headerHeight
//
////        navigationTitleButton.customText.text = isScrolledPastHeader ? "신논현동" : "보관함"
////        navigationTitleButton.customImage.isHidden = !isScrolledPastHeader
////        navigationTitleButton.isEnabled = isScrolledPastHeader
////        navigationTitleButton.updateConstraint()
//    }
}
