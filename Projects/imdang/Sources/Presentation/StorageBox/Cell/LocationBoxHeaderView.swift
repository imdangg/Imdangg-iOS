//
//  LocationBoxHeaderView.swift
//  imdang
//
//  Created by 임대진 on 12/15/24.
//

import UIKit
import Then
import RxSwift
import RxCocoa

class LocationBoxHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "LocationBoxHeaderView"
    weak var delegate: ReusableViewDelegate?
    private var disposeBag = DisposeBag()
    private var collectionView: UICollectionView?
    private var totalPage = 1 {
        didSet {
            updatePageLabel()
        }
    }
    private var currentPage = 1 {
        didSet {
            updatePageLabel()
        }
    }
    
    private let pageLabel = UILabel().then {
        $0.text = "1 / 4"
        $0.font = .pretenSemiBold(14)
        $0.textAlignment = .center
        $0.textColor = .mainOrange500
        $0.backgroundColor = .mainOrange50
        
        $0.layer.cornerRadius = 14
        $0.clipsToBounds = true
    }
    
    let fullViewBotton = UIButton().then {
        $0.setTitle("전체보기", for: .normal)
        $0.titleLabel?.font = .pretenRegular(14)
        $0.setTitleColor(.grayScale700, for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        addSubViews()
        makeConstraints()
        bindActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        currentPage = 1
        
        delegate = nil
        collectionView = nil
        bindActions()
    }

    
    
    func addSubViews() {
        [pageLabel, fullViewBotton].forEach {
            addSubview($0)
        }
    }
    
    private func makeConstraints() {
        
        pageLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.equalTo(44)
            $0.height.equalTo(28)
        }
        
        fullViewBotton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }
    
    private func updatePageLabel() {
        pageLabel.text = "\(currentPage) / \(totalPage)"
    }
    
    func bindActions() {
        fullViewBotton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.delegate?.didTapFullViewButton()
            })
            .disposed(by: disposeBag)
    }
    
    func bind(input: Observable<Int>, totalPage: Int, indexPath: IndexPath, collectionView: UICollectionView) {
        self.collectionView = collectionView
        self.totalPage = totalPage
        
        input
            .subscribe(onNext: { [weak self] currentPage in
                self?.currentPage = currentPage + 1
            })
            .disposed(by: disposeBag)
    }
}
