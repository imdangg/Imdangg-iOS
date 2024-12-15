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
import UIKit

final class StorageBoxViewController: UIViewController {
    private var collectionView: UICollectionView!
    private let disposeBag = DisposeBag()
    private let currentPage = PublishSubject<Int>()
    
    private let navigationLineView = UIView().then {
        $0.backgroundColor = .grayScale100
    }
    
    private let navigationTitleLabel = UILabel().then {
        $0.text = "보관함"
        $0.font = .pretenBold(24)
        $0.textColor = .grayScale900
    }
    
    private let mapButton = ImageTextButton(imagePadding: 8, textPadding: 4).then {
        $0.iconImageView.image = ImdangImages.Image(resource: .mapButtonGray)
        $0.textLabel.text = "지도"
        $0.textLabel.font = .pretenMedium(12)
        $0.textLabel.textColor = .grayScale700
        
        $0.layer.cornerRadius = 4
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.grayScale200.cgColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigationBgColor(backgroundColor: .white)
        setNavigationItem()
        configureCollectionView()
    }
    
    private func setNavigationItem() {
        let leftContainerView = UIView()
        leftContainerView.addSubview(navigationTitleLabel)
        let leftView = UIBarButtonItem(customView: leftContainerView)
        
        let rightContainerView = UIView()
        rightContainerView.addSubview(mapButton)
        let rightView = UIBarButtonItem(customView: rightContainerView)
          
        self.navigationItem.leftBarButtonItem = leftView
        self.navigationItem.rightBarButtonItem = rightView
        
        view.addSubview(navigationLineView)
        
        navigationLineView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.height.equalTo(1)
            $0.horizontalEdges.equalToSuperview()
        }
        
        navigationTitleLabel.snp.makeConstraints {
            $0.width.equalTo(63)
            $0.height.equalTo(34)
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 6, bottom: 0, right: 0))
        }
        
        mapButton.snp.makeConstraints {
            $0.width.equalTo(57)
            $0.height.equalTo(32)
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 6))
        }
    }
    
    private func configureCollectionView() {
        let layout = createCompositionalLayout()
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.register(cell: LocationBoxCollectionCell.self)
        collectionView.register(cell: InsightCollectionCell.self)
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(SectionSeparatorView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: SectionSeparatorView.reuseIdentifier)
        
        collectionView.register(InsightHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: InsightHeaderView.reuseIdentifier)
        collectionView.register(LocationBoxHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: LocationBoxHeaderCell.reuseIdentifier)
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(navigationLineView.snp.bottom)
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
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 0)
        separator.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: -20, bottom: 0, trailing: 0)
        header.contentInsets = NSDirectionalEdgeInsets(top: -32, leading: 0, bottom: 0, trailing: 20)
        
        section.orthogonalScrollingBehavior = .groupPaging
        section.visibleItemsInvalidationHandler = { [weak self] _, contentOffset, environment in
            let containerWidth = environment.container.contentSize.width
            let itemWidth = environment.container.contentSize.width
            let pageIndex = Int(max(0, round(contentOffset.x / itemWidth)))

            if containerWidth > 0 {
                self?.currentPage.onNext(pageIndex)
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

extension StorageBoxViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 10 : 20
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            
            switch indexPath.section {
            case 0:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: InsightHeaderView.reuseIdentifier, for: indexPath) as! InsightHeaderView
                headerView.bind(input: currentPage.asObservable(), indexPath: indexPath, collectionView: collectionView)
                return headerView
            case 1:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LocationBoxHeaderCell.reuseIdentifier, for: indexPath) as! LocationBoxHeaderCell
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
            if indexPath.item == 0 {
                cell.backgroundColor = .mainOrange500
            }
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath, cellType: InsightCollectionCell.self)
            
            let testImage = "https://s3-alpha-sig.figma.com/img/bfd4/929c/86aa0d3566cba94912f0b4d10410b9b2?Expires=1733702400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=jVznuLFIzwecr875Ecx3wk6BTv7gmC1~-b0UoCUkxJI8rSjqu-NfEArK9bTrf~soTgQ9P8Dw-SGQaoN-k1R4nUTC1mz8Svwhdw7nd8YWWVbLO3a7nmdUH3oLTVfR0uqwvjJbVKPb7Pf3KQzXOHBp1o0JLhOt0sTYBMt8B2p47EYJe0QKTNrlmJDSQgJQCEyudHAyBl9WhC5CLU3UYHgN1VC9Ao6DbMkJusxmT3INQ3w-gHrvlovCvbLsBNvMTVlq4H7hAFzxLhR8ySqJ2cNzP7v-LyB2AwWIC15vYjs7lhctVXclsngtwPcUCSkaT53ghxo-TfB8bhZznInDWcTg0w__"
            let insight = Insight(id: 0, titleName: "초역세권 대단지 아파트 후기", titleImageUrl: testImage, userName: "홍길동", profileImageUrl: "", adress: "강남구 신논현동", likeCount: 20)
            cell.configure(insight: insight, layoutType: .horizontal)
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            
            return cell
        }
    }
}
