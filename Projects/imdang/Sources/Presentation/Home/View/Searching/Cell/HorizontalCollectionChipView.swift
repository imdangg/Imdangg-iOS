//
//  HorizontalCollectionView.swift
//  imdang
//
//  Created by daye on 12/15/24.

import SnapKit
import UIKit
import RxCocoa
import RxSwift


// [FIXME]
class HorizontalCollectionChipView: UIView {
    
    // Mock
    private var items: [String] = ["신논현 더 센트럴 푸르지오 1", "신논현 더 센트럴 푸르지오 2", "신논현 더 센트럴 푸르지오 3", "신논현 더 센트럴 푸르지오 4", "신논현 더 센트럴 푸르지오 5", "신논현 더 센트럴 푸르지오 6"]
    
    private let selectedItem = BehaviorRelay<String?>(value: nil)
    private let disposeBag = DisposeBag()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "HorizontalCell")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "FooterView")
        collectionView.allowsSelection = true
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        bindCollectionView()
        setDefaultSelection()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setDefaultSelection() {
        selectedItem.accept(items.first)
    }
    
    private func setupView() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { $0.edges.equalToSuperview() }
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func bindCollectionView() {
        selectedItem
            .subscribe(onNext: { [weak self] selected in
                self?.collectionView.reloadSections([0])
                if let selected = selected {
                    print("아파트 이름\(selected)")
                }
            })
            .disposed(by: disposeBag)
    }
    
    func updateItems(_ newItems: [String]) {
        items = newItems
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension HorizontalCollectionChipView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HorizontalCell", for: indexPath)
        
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        let label = UILabel()
        label.text = items[indexPath.item]
        label.textAlignment = .center
        label.textColor = .white
        label.font = .pretenMedium(14)
        label.frame = cell.contentView.bounds
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        cell.contentView.addSubview(label)
        
        if items[indexPath.item] == selectedItem.value {
            cell.backgroundColor = .mainOrange500
            label.textColor = .white
            cell.layer.borderColor = UIColor.mainOrange500.cgColor
            cell.layer.borderWidth = 0
        } else {
            cell.backgroundColor = .white
            cell.layer.borderColor = UIColor.grayScale100.cgColor
            cell.layer.borderWidth = 1
            label.textColor = UIColor.grayScale500
        }
        cell.layer.cornerRadius = 18
        cell.layer.masksToBounds = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath)
            headerView.backgroundColor = .clear
            return headerView
        } else if kind == UICollectionView.elementKindSectionFooter {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FooterView", for: indexPath)
            footerView.backgroundColor = .clear
            return footerView
        }
        
        return UICollectionReusableView()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HorizontalCollectionChipView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = items[indexPath.item]
        let label = UILabel()
        label.text = text
        label.sizeToFit()
        return CGSize(width: label.frame.width + 8, height: 36) // 얘도 뭔가 다름
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    // 여백용
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 20, height: 36)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 20, height: 36)
    }
}

// MARK: - UICollectionViewDelegate
extension HorizontalCollectionChipView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = items[indexPath.item]
        self.selectedItem.accept(selectedItem)
    }
}
