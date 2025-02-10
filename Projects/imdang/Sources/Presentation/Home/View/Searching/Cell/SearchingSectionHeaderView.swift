//
//  SearchingSectionHeaderView.swift
//  imdang
//
//  Created by 임대진 on 11/26/24.
//

import UIKit
import RxSwift
import RxCocoa

enum HeaderType {
    case topten
    case notTopten
}

class SearchingSectionHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "SearchingSectionHeaderView"
    
    var buttonAction: (() -> Void)?
    let selectedItem = BehaviorRelay<String?>(value: nil)
    private var disposeBag = DisposeBag()
    private var collectionView: UICollectionView?
    private var currentPage = 1 {
        didSet {
            updatePageLabel()
        }
    }
    
    private var headerType: HeaderType? {
        didSet {
            guard let type = headerType else { return }
            resetConstraints()
            configureLayout(type: type)
        }
    }
    
    private var isShowHorizontalCollectionChipView: Bool? = false {
        didSet {
            resetConstraints()
            if let headerType = headerType {
                configureLayout(type: headerType)
            }
        }
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .pretenSemiBold(18)
        $0.textColor = .grayScale900
        $0.numberOfLines = 1
    }
    
    private let fullViewBotton = UIButton().then {
        $0.setTitle("전체보기", for: .normal)
        $0.titleLabel?.font = .pretenRegular(14)
        $0.setTitleColor(.grayScale700, for: .normal)
    }
    
    private let currentPageLabel = UILabel().then {
        $0.text = "1"
        $0.font = .pretenSemiBold(14)
        $0.textColor = .mainOrange500
        $0.textAlignment = .center
    }
    
    private let totalPageLabel = UILabel().then {
        $0.text = " / 4"
        $0.font = .pretenRegular(14)
        $0.textColor = .grayScale700
        $0.textAlignment = .center
    }
    
    var chipView = HorizontalCollectionChipView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bindAction()
    }
    
    override func prepareForReuse() {
        chipView = HorizontalCollectionChipView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updatePageLabel() {
        currentPageLabel.text = "\(currentPage)"
    }
    
    private func resetConstraints() {
        subviews.forEach { $0.removeFromSuperview() }
    }
    
    private func configureLayout(type: HeaderType) {
        
        addSubview(titleLabel)
        
        if let shouldShowHorizontal = isShowHorizontalCollectionChipView, shouldShowHorizontal {
            
            addSubview(chipView)
            
            titleLabel.snp.remakeConstraints {
                $0.top.equalToSuperview()
                $0.leading.equalToSuperview()
                $0.trailing.equalToSuperview()
                $0.height.equalTo(25)
            }
            
            chipView.snp.makeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(16)
                $0.horizontalEdges.equalToSuperview().inset(-20) //바깥 여백 없애기
                $0.height.equalTo(36)
            }
        } else {
            titleLabel.snp.remakeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        switch type {
        case .topten:
            addSubview(totalPageLabel)
            addSubview(currentPageLabel)
            totalPageLabel.snp.makeConstraints {
                $0.centerY.equalTo(titleLabel.snp.centerY)
                $0.trailing.equalToSuperview()
            }
            currentPageLabel.snp.makeConstraints {
                $0.centerY.equalTo(titleLabel.snp.centerY)
                $0.trailing.equalTo(totalPageLabel.snp.leading)
            }
        case .notTopten:
            addSubview(fullViewBotton)
            fullViewBotton.snp.makeConstraints {
                $0.centerY.equalTo(titleLabel.snp.centerY)
                $0.trailing.equalToSuperview()
            }
        }
    }
    
    private func bindAction() {
        fullViewBotton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.buttonAction?()
            }
            .disposed(by: disposeBag)
    }
    
    func configure(with title: String, type: HeaderType, showHorizontalCollection: Bool, aptItems: [String]? = nil, index: Int = 0) {
        titleLabel.text = title
        headerType = type
        isShowHorizontalCollectionChipView = showHorizontalCollection
        
        if type == .topten {
            let attributedString = NSMutableAttributedString(string: title)
            let range = (title as NSString).range(of: "TOP 10")
            attributedString.addAttribute(.foregroundColor, value: UIColor.mainOrange500, range: range)
            
            titleLabel.attributedText = attributedString
        }
        
        if let aptItems {
            chipView.updateItems(aptItems, index: index)
        }
    }
    
    func bind(input: Observable<Int>, indexPath: IndexPath, collectionView: UICollectionView) {
        self.collectionView = collectionView
        
        input
            .subscribe(onNext: { [weak self] currentPage in
                self?.currentPage = currentPage + 1
            })
            .disposed(by: disposeBag)
        
    }
}
