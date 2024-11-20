//
//  HomeContainerViewController.swift
//  imdang
//
//  Created by 임대진 on 11/20/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Then

class HomeContainerViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    private let searchViewController = EmptyViewController(labelText: "탐색뷰")
    private let exchangeViewController = EmptyViewController(labelText: "교환뷰")
    
    private let searchButton = UIButton().then {
        $0.setTitle("탐색", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .pretenBold(24)
    }
    
    private let exchangeButton = UIButton().then {
        $0.setTitle("교환소", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .pretenBold(24)
    }
    
    private let alramButton = UIButton().then {
        $0.setImage(ImdangImages.Image(resource: .alarm), for: .normal)
        $0.frame.size = CGSize(width: 40, height: 40)
    }
    
    private let myPageButton = UIButton().then {
        $0.setImage(ImdangImages.Image(resource: .person), for: .normal)
        $0.frame.size = CGSize(width: 40, height: 40)
    }
    
    private let searchView = UIView().then {
        $0.backgroundColor = .white
        $0.isHidden = false
    }
    
    private let exchangeView = UIView().then {
        $0.backgroundColor = .white
        $0.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addSubviews()
        makeConstraints()
        configNavigationBarItem()
        bindActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configNavigationBarItem()
    }
    
    private func addSubviews() {
        [searchView, exchangeView].forEach { view.addSubview($0) }
        
        addChild(searchViewController)
        addChild(exchangeViewController)
        
        searchView.addSubview(searchViewController.view)
        exchangeView.addSubview(exchangeViewController.view)
        
        searchViewController.didMove(toParent: self)
        exchangeViewController.didMove(toParent: self)
    }
    
    private func makeConstraints() {
        
        searchView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        exchangeView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        searchViewController.view.snp.makeConstraints {
            $0.edges.equalTo(searchView)
        }
        
        exchangeViewController.view.snp.makeConstraints {
            $0.edges.equalTo(exchangeView)
        }
    }
    
    private func configNavigationBarItem() {
        let searchButton = UIBarButtonItem(customView: searchButton)
        let exchangeButton = UIBarButtonItem(customView: exchangeButton)
        let alramButton = UIBarButtonItem(customView: alramButton)
        let myPageButton = UIBarButtonItem(customView: myPageButton)
        
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedSpace.width = 24
        
        navigationItem.leftBarButtonItems = [searchButton, fixedSpace, exchangeButton]
        navigationItem.rightBarButtonItems = [myPageButton, fixedSpace, alramButton]
    }
    
    private func bindActions() {
        searchButton.rx.tap
            .subscribe(onNext: { _ in
                self.searchView.isHidden = false
                self.exchangeView.isHidden = true
            })
            .disposed(by: disposeBag)
        
        exchangeButton.rx.tap
            .subscribe(onNext: { _ in
                self.searchView.isHidden = true
                self.exchangeView.isHidden = false
            })
            .disposed(by: disposeBag)
    }
}
