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
    
    private let searchViewController = SearchingViewController()
    private let exchangeViewController = EmptyViewController(labelText: "교환뷰")
    
    private let searchButton = UIButton().then {
        $0.setTitle("탐색", for: .normal)
        $0.setTitleColor(.grayScale900, for: .normal)
        $0.titleLabel?.font = .pretenBold(24)
    }
    
    private let exchangeButton = UIButton().then {
        $0.setTitle("교환소", for: .normal)
        $0.setTitleColor(.grayScale500, for: .normal)
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
        let leftStackView = UIStackView.init(arrangedSubviews: [searchButton, exchangeButton])
        leftStackView.distribution = .equalSpacing
        leftStackView.axis = .horizontal
        leftStackView.alignment = .center
        leftStackView.spacing = 24
        
        
        let rightStackView = UIStackView.init(arrangedSubviews: [alramButton, myPageButton])
        rightStackView.distribution = .equalSpacing
        rightStackView.axis = .horizontal
        rightStackView.alignment = .center
        rightStackView.spacing = 16
        
        let leftView = UIBarButtonItem(customView: leftStackView)
        let rightView = UIBarButtonItem(customView: rightStackView)
        
        navigationItem.leftBarButtonItems = [leftView]
        navigationItem.rightBarButtonItems = [rightView]
    }
    
    private func bindActions() {
        searchButton.rx.tap
            .subscribe(onNext: { [weak self] state in
                self?.searchView.isHidden = false
                self?.exchangeView.isHidden = true
                self?.exchangeButton.setTitleColor(.grayScale500, for: .normal)
                self?.searchButton.setTitleColor(.grayScale900, for: .normal)
            })
            .disposed(by: disposeBag)
        
        exchangeButton.rx.tap
            .subscribe(onNext: { [weak self] state in
                self?.searchView.isHidden = true
                self?.exchangeView.isHidden = false
                self?.searchButton.setTitleColor(.grayScale500, for: .normal)
                self?.exchangeButton.setTitleColor(.grayScale900, for: .normal)
            })
            .disposed(by: disposeBag)
    }
}
