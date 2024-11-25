//
//  SearchingViewController.swift
//  SharedLibraries
//
//  Created by 임대진 on 11/26/24.
//

import UIKit
import SnapKit
import Then

class SearchingViewController: UIViewController {
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()).then {
        $0.backgroundColor = .white
        $0.register(cell: InsightCollectionCell.self)
        $0.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.setCollectionViewLayout(createLayout(), animated: false)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(SearchingSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchingSectionHeaderView.reuseIdentifier)
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            if sectionIndex == 0 {
                return self.createPagingSection()
            } else if sectionIndex == 1 {
                return self.createHorizonSection()
            } else {
                return self.createPagingSection()
            }
        }
    }
    
    private func createHorizonSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(200), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func createPagingSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(336))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
}

extension SearchingViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SearchingSectionHeaderView.reuseIdentifier, for: indexPath) as! SearchingSectionHeaderView
            
            switch indexPath.section {
            case 0:
                headerView.configure(with: "내가 작성한 단지 인사이트")
            case 1:
                headerView.configure(with: "오늘 새롭게 올라온 인사이트")
            case 2:
                headerView.configure(with: "추천수 TOP 10 인사이트")
            default:
                headerView.configure(with: "섹션")
            }
            
            return headerView
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            cell.backgroundColor = .systemGreen
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath, cellType: InsightCollectionCell.self)
        
        let insight = Insight(id: 0, titleName: "test", titleImageUrl: "https://s3-alpha-sig.figma.com/img/bfd4/929c/86aa0d3566cba94912f0b4d10410b9b2?Expires=1733702400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=jVznuLFIzwecr875Ecx3wk6BTv7gmC1~-b0UoCUkxJI8rSjqu-NfEArK9bTrf~soTgQ9P8Dw-SGQaoN-k1R4nUTC1mz8Svwhdw7nd8YWWVbLO3a7nmdUH3oLTVfR0uqwvjJbVKPb7Pf3KQzXOHBp1o0JLhOt0sTYBMt8B2p47EYJe0QKTNrlmJDSQgJQCEyudHAyBl9WhC5CLU3UYHgN1VC9Ao6DbMkJusxmT3INQ3w-gHrvlovCvbLsBNvMTVlq4H7hAFzxLhR8ySqJ2cNzP7v-LyB2AwWIC15vYjs7lhctVXclsngtwPcUCSkaT53ghxo-TfB8bhZznInDWcTg0w__", userName: "임대진", profileImageUrl: "", adress: "용인시 수지구", likeCount: 20)
        cell.configure(insight: insight)
        return cell
    }
}
