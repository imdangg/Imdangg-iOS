//
//  MapViewController.swift
//  imdang
//
//  Created by 임대진 on 2/5/25.
//

import UIKit
import SnapKit
import Then

enum MapType {
    case search, storage
}

class MapViewController: BaseViewController {
    private let titleLable = UILabel().then {
        $0.font = .pretenSemiBold(18)
        $0.textColor = .grayScale900
    }
    
    private let backView = UIView()
    
    private let mapIcon = UIImageView().then {
        $0.image = ImdangImages.Image(resource: .mapEmpty76)
    }
    
    private let descriptionLable = UILabel().then {
        $0.text = "지도 서비스는 현재 준비중이에요.\n조금만 더 기다려 주세요."
        $0.font = .pretenSemiBold(18)
        $0.textColor = .grayScale500
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customBackButton.isHidden = false
        
        addSubviews()
        makeConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if titleLable.text == "지도로 찾기" {
            AnalyticsService().screenEvent(ScreenName: .searchingWithMap)
        } else if titleLable.text == "지도로 탐색" {
            AnalyticsService().screenEvent(ScreenName: .findWithMap)
        }
    }
    
    private func addSubviews() {
        leftNaviItemView.addSubview(titleLable)
        
        [mapIcon, descriptionLable].forEach { backView.addSubview($0) }
        
        view.addSubview(backView)
    }
    
    private func makeConstraints() {
        titleLable.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(12)
        }
        
        mapIcon.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
        descriptionLable.snp.makeConstraints {
            $0.top.equalTo(mapIcon.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        backView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func config(type: MapType) {
        switch type {
        case .search:
            titleLable.text = "지도로 탐색"
        case .storage:
            titleLable.text = "지도로 보기"
        }
    }
}
