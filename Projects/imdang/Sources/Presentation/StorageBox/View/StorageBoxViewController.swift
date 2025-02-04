//
//  StorageBoxViewController.swift
//  SharedLibraries
//
//  Created by 임대진 on 12/7/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Then

final class StorageBoxViewController: BaseViewController {
    private var pageIndex = 0
    private var currentaddress: AddressResponse?
    private var toggleState = false
    private let disposeBag = DisposeBag()
    
    private let currentPage = BehaviorRelay<Int>(value: 1)
    private let addresses = BehaviorRelay<[AddressResponse]>(value: [])
    private let insights = BehaviorRelay<[Insight]>(value: [])
    
    private let storageBoxViewModel = StorageBoxViewModel()
    
    private var collectionView: UICollectionView!
    
    private let navigationTitleButton = ImageTextButton(type: .textFirst, horizonPadding: 0, spacing: 8).then {
        $0.customText.text = "보관함"
        $0.customText.textColor = .grayScale900
        $0.customText.font = .pretenBold(24)
        $0.customImage.image = ImdangImages.Image(resource: .chevronDown).withRenderingMode(.alwaysTemplate)
        $0.imageSize = 20
        $0.customImage.tintColor = .grayScale900
        $0.customImage.isHidden = true
    }
    
    private let mapButton = ImageTextButton(type: .imageFirst, horizonPadding: 8, spacing: 4).then {
        $0.customImage.image = ImdangImages.Image(resource: .mapButtonGray)
        $0.customText.text = "지도"
        $0.customText.font = .pretenMedium(12)
        $0.customText.textColor = .grayScale700
        
        $0.layer.cornerRadius = 4
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.grayScale200.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let _ = collectionView, !addresses.value.isEmpty {
            let indexPath = IndexPath(item: 0, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationItem()
        configureCollectionView()
        bindActions()
    }
    
    private func setNavigationItem() {
        leftNaviItemView.addSubview(navigationTitleButton)
        rightNaviItemView.addSubview(mapButton)
        
        navigationTitleButton.snp.makeConstraints {
            $0.height.equalTo(34)
            $0.width.equalTo(100)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        mapButton.snp.makeConstraints {
            $0.width.equalTo(57)
            $0.height.equalTo(32)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }
    
    private func configureCollectionView() {
        let layout = createCompositionalLayout()
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        collectionView.register(cell: LocationBoxCollectionCell.self)
        collectionView.register(cell: InsightCollectionCell.self)
        collectionView.register(cell: EmptyMyInsightCollectionCell.self)
        
        collectionView.register(header: InsightHeaderView.self)
        collectionView.register(header: LocationBoxHeaderView.self)
        
        collectionView.register(footer: SectionSeparatorView.self)
        
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
                return self.createHorizontalScrollSection()
            case 1:
                return self.createStickyHeaderSection()
            default:
                return nil
            }
        }
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
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20)
        separator.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: -20, bottom: 0, trailing: -20)
        header.contentInsets = NSDirectionalEdgeInsets(top: -32, leading: 0, bottom: 0, trailing: 0)
        
        section.orthogonalScrollingBehavior = .groupPaging
        section.visibleItemsInvalidationHandler = { [weak self] _, contentOffset, environment in
            guard let self = self else { return }
            let containerWidth = environment.container.contentSize.width
            let itemWidth = environment.container.contentSize.width
            let pageIndex = Int(max(0, round(contentOffset.x / itemWidth)))

            if containerWidth > 0 {
                currentPage.accept(pageIndex)
            }
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
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(122))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: -20, bottom: 0, trailing: -20)
        header.pinToVisibleBounds = true // 헤더 고정
        
        section.boundarySupplementaryItems = [header]
        return section
    }
    
    private func bindActions() {
        navigationTitleButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let vc = AreaListViewController()
                vc.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        currentPage
            .distinctUntilChanged()
            .subscribe(with: self) { owner, currentPage in
                if !owner.addresses.value.isEmpty {
                    owner.pageIndex = 0
                    owner.loadInsightData(address: owner.addresses.value[currentPage])
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func loadInsightData(address: AddressResponse) {
        storageBoxViewModel.loadStoregeInsights(address: address, pageIndex: pageIndex, onlyMine: toggleState)
            .compactMap { $0 }
            .subscribe(with: self) { owner, data in
                owner.currentaddress = address
                owner.insights.accept(data)
                owner.collectionView.reloadSections(IndexSet(integer: 1))
                owner.storageBoxViewModel.isLoading = false
            }
            .disposed(by: disposeBag)
    }
    
    func config(addresses: [AddressResponse]) {
        guard let first = addresses.first else { return }
        self.currentaddress = first
        self.addresses.accept(addresses)
        self.pageIndex = 0
        
        storageBoxViewModel.loadStoregeInsights(address: first, pageIndex: 0)
            .compactMap { $0 }
            .subscribe(with: self) { owner, data in
                owner.insights.accept(data)
                owner.collectionView.reloadData()
            }
            .disposed(by: disposeBag)
    }
}

extension StorageBoxViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? addresses.value.count : insights.value.isEmpty ? 1 : insights.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            
            switch indexPath.section {
            case 0:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LocationBoxHeaderView.reuseIdentifier, for: indexPath) as! LocationBoxHeaderView
                headerView.bind(input: currentPage.asObservable(), totalPage: addresses.value.count, indexPath: indexPath, collectionView: collectionView)
                headerView.delegate = self
                
                return headerView
            case 1:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: InsightHeaderView.reuseIdentifier, for: indexPath) as! InsightHeaderView
                headerView.delegate = self
                headerView.config(insightCount: storageBoxViewModel.totalCount, toggleState: self.toggleState)
                return headerView
            default:
                return UICollectionReusableView()
            }
        } else {
            switch indexPath.section {
            case 0:
                let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionSeparatorView.reuseIdentifier, for: indexPath) as! SectionSeparatorView
                return footerView
            case 1:
                return UICollectionReusableView()
            default:
                return UICollectionReusableView()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath, cellType: LocationBoxCollectionCell.self)
            cell.bind(input: currentPage.asObservable(), pageIndex: indexPath.item)
            cell.configure(address: addresses.value[indexPath.row])
            cell.setTintColor(visiable: indexPath.item == 0)
            return cell
        case 1:
            if insights.value.isEmpty {
                let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath, cellType: EmptyMyInsightCollectionCell.self)
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath, cellType: InsightCollectionCell.self)
                cell.configure(insight: insights.value[indexPath.row], layoutType: .horizontal)
                return cell
            }
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            storageBoxViewModel.loadInsightDetail(id: insights.value[indexPath.row].insightId)
                .subscribe { [self] data in
                    if let data = data {
                        let vc = InsightDetailViewController(url: "", insight: data)
                        vc.hidesBottomBarWhenPushed = true
                        navigationController?.pushViewController(vc, animated: true)
                    }
                }
                .disposed(by: disposeBag)
        default:
            break
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let headerHeight: CGFloat = 220
        let isScrolledPastHeader = scrollView.contentOffset.y >= headerHeight

        navigationTitleButton.customText.text = isScrolledPastHeader ? currentaddress?.toEupMyeonDongs() ?? "" : "보관함"
        navigationTitleButton.customImage.isHidden = !isScrolledPastHeader
        navigationTitleButton.isEnabled = isScrolledPastHeader
        navigationTitleButton.updateConstraint()
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - scrollViewHeight - 100 { // 100px 여유
//            loadMoreData() // 서버 페이징 처리 안되어있음
        }
    }
    
    private func loadMoreData() {
        guard !storageBoxViewModel.isLoading else { return }
        guard pageIndex < storageBoxViewModel.totalPage else { return }
        guard let address = currentaddress else { return }
        
        storageBoxViewModel.isLoading = true
        pageIndex += 1
        
        loadInsightData(address: address)
    }
}

extension StorageBoxViewController: ReusableViewDelegate {
    func disTapSortButton(isOn: Bool) {
        toggleState = isOn
        pageIndex = 0
        loadInsightData(address: addresses.value[currentPage.value])
    }
    
    func didTapFullViewButton() {
        let vc = AreaListViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapAreaSeletButton() {
        let modalVC = AreaModalViewController()
        modalVC.modalPresentationStyle = .pageSheet
        modalVC.modalTransitionStyle = .coverVertical
        self.present(modalVC, animated: true, completion: nil)
    }
}
