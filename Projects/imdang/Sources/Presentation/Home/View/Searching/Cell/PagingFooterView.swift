//
//  PagingFooterView.swift
//  imdang
//
//  Created by 임대진 on 12/3/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class PagingFooterView: UICollectionReusableView {
    static let reuseIdentifier = "PagingFooterView"
    private let disposeBag = DisposeBag()
    
    private let pageControl = UIPageControl().then {
        $0.currentPage = 0
        $0.numberOfPages = 4
        $0.pageIndicatorTintColor = .grayScale100
        $0.currentPageIndicatorTintColor = .mainOrange500
        
        $0.isUserInteractionEnabled = false
    }
    
    private var collectionView: UICollectionView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(pageControl)
        pageControl.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func bind(input: Observable<Int>, indexPath: IndexPath, collectionView: UICollectionView) {
        self.collectionView = collectionView
        
        input
            .subscribe(onNext: { [weak self] currentPage in
                self?.pageControl.currentPage = currentPage
            })
            .disposed(by: disposeBag)

    }
}
