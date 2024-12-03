//
//  SearchingViewController.swift
//  SharedLibraries
//
//  Created by 임대진 on 11/26/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa


class SearchingViewController: UIViewController {
    private let currentrPage = PublishSubject<Int>()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()).then {
        $0.backgroundColor = .white
        $0.register(cell: InsightCollectionCell.self)
        $0.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "BannerCell")
    }
    private let bannerImageView = BannerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.setCollectionViewLayout(createLayout(), animated: false)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(SearchingSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchingSectionHeaderView.reuseIdentifier)
        
        collectionView.register(PagingFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: PagingFooterView.reuseIdentifier)
        collectionView.register(SectionSeparatorView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: SectionSeparatorView.reuseIdentifier)
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            switch sectionIndex {
            case 0: return self.createBannerLayout()
            case 1: return self.createFirstSectionLayout()
            case 2: return self.createSecondSectionLayout()
            case 3: return self.createThirdSectionLayout()
            default: return nil
            }
        }
    }
    
    private func createBannerLayout() -> NSCollectionLayoutSection {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(96))
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0)
        return section
    }

    private func createFirstSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(336))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 3)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20)
        
        let separatorSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(8))
        let separator = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: separatorSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )
        separator.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0)

        
        section.boundarySupplementaryItems = [header, separator]
        
        return section
    }
    
    private func createSecondSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(300))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(200), heightDimension: .absolute(300))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 40, bottom: 20, trailing: 0)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
        section.interGroupSpacing = 12

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        header.contentInsets = NSDirectionalEdgeInsets(top: -20, leading: 20, bottom: 0, trailing: 20)
        
        let separatorSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(8))
        let separator = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: separatorSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )

        section.boundarySupplementaryItems = [header, separator]

        return section
    }
    
    private func createThirdSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(336))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0)
        
        
        section.visibleItemsInvalidationHandler = { [weak self] _, contentOffset, environment in
            let containerWidth = environment.container.contentSize.width
            let itemWidth = environment.container.contentSize.width
            let pageIndex = Int(max(0, round(contentOffset.x / itemWidth)))

            if containerWidth > 0 {
                self?.currentrPage.onNext(pageIndex)
            }
        }

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        header.contentInsets = NSDirectionalEdgeInsets(top: -20, leading: 0, bottom: 0, trailing: 20)
        
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(54))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        section.boundarySupplementaryItems = [header, footer]
        
        return section
    }

}

extension SearchingViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 3
        case 2: return 20
        case 3: return 10
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SearchingSectionHeaderView.reuseIdentifier, for: indexPath) as! SearchingSectionHeaderView
            
            switch indexPath.section {
            case 0:
                return UICollectionReusableView()
            case 1:
                headerView.configure(with: "내가 작성한 단지 인사이트", type: .notTopten)
            case 2:
                headerView.configure(with: "오늘 새롭게 올라온 인사이트", type: .notTopten)
            case 3:
                headerView.configure(with: "추천수 TOP 10 인사이트", type: .topten)
            default:
                return UICollectionReusableView()
            }
            
            return headerView
        } else if kind == UICollectionView.elementKindSectionFooter {
            switch indexPath.section {
            case 0:
                return UICollectionReusableView()
            case 1:
                let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionSeparatorView.reuseIdentifier, for: indexPath) as! SectionSeparatorView
                return footerView
            case 2:
                let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionSeparatorView.reuseIdentifier, for: indexPath) as! SectionSeparatorView
                return footerView
            case 3:
                let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PagingFooterView.reuseIdentifier, for: indexPath) as! PagingFooterView
                footerView.bind(input: currentrPage.asObservable(), indexPath: indexPath, pageNumber: 4, collectionView: collectionView)
                return footerView
            default:
                return UICollectionReusableView()
            }
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let testImage = "https://s3-alpha-sig.figma.com/img/bfd4/929c/86aa0d3566cba94912f0b4d10410b9b2?Expires=1733702400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=jVznuLFIzwecr875Ecx3wk6BTv7gmC1~-b0UoCUkxJI8rSjqu-NfEArK9bTrf~soTgQ9P8Dw-SGQaoN-k1R4nUTC1mz8Svwhdw7nd8YWWVbLO3a7nmdUH3oLTVfR0uqwvjJbVKPb7Pf3KQzXOHBp1o0JLhOt0sTYBMt8B2p47EYJe0QKTNrlmJDSQgJQCEyudHAyBl9WhC5CLU3UYHgN1VC9Ao6DbMkJusxmT3INQ3w-gHrvlovCvbLsBNvMTVlq4H7hAFzxLhR8ySqJ2cNzP7v-LyB2AwWIC15vYjs7lhctVXclsngtwPcUCSkaT53ghxo-TfB8bhZznInDWcTg0w__"
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCell", for: indexPath)
            cell.addSubview(bannerImageView)
            bannerImageView.snp.makeConstraints { $0.edges.equalToSuperview() }
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath, cellType: InsightCollectionCell.self)
            
            let insight = Insight(id: 0, titleName: "초역세권 대단지 아파트 후기", titleImageUrl: testImage, userName: "홍길동", profileImageUrl: "", adress: "강남구 신논현동", likeCount: 20)
            cell.configure(insight: insight, layoutType: .horizontal)
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath, cellType: InsightCollectionCell.self)
            
            let insight = Insight(id: 0, titleName: "초역세권 대단지 아파트 후기", titleImageUrl: testImage, userName: "홍길동", profileImageUrl: "", adress: "강남구 신논현동", likeCount: 20)
            cell.configure(insight: insight, layoutType: .vertical)
            return cell
        case 3:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath, cellType: InsightCollectionCell.self)
            
            let insight = Insight(id: 0, titleName: "초역세권 대단지 아파트 후기", titleImageUrl: testImage, userName: "홍길동", profileImageUrl: "", adress: "강남구 신논현동", likeCount: 20)
            cell.configure(insight: insight, layoutType: .horizontal)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}
