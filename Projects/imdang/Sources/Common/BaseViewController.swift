//
//  BaseViewController.swift
//  imdang
//
//  Created by 임대진 on 12/20/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

/*
 사용법: 상속해서 사용하시면 됩니다
 class MainViewController: BaseViewController {
     let item = UIView()
     let tableView = UITableView()
     
     override func viewDidLoad() {
         super.viewDidLoad()
         
         // 백버튼 필요시 (기본값: 숨김)
         customBackButton.isHidden = false
         
         // 왼쪽 네비게이션 아이템 추가
         leftNaviItemView.addSubview(item)
         leftNaviItemView.snp.makeConstraints {
             $0.width.height.equalTo(20)
             $0.centerY.equalToSuperview()
             $0.leading.equalToSuperview().offset(10) // 백버튼 숨김과 관련없이 equalToSuperview로 하시면됩니다
         }
         
         // 오른쪽 네비게이션 아이템 추가
         rightNaviItemView.addSubview(item)
         
         // 네비게이션바 하단에 레이아웃 적용방법
         tableView.snp.makeConstraints {
             $0.topEqualToNavigationBottom(vc: self)
         }
     }
 }
 */

class BaseViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    private let leftNavigtaionView = UIStackView().then {
        $0.alignment = .leading
    }
    
    private let rightNavigtaionView = UIStackView().then {
        $0.alignment = .trailing
    }
    
    let leftNaviItemView = UIView()
    let rightNaviItemView = UIView()
    
    let customBackButton = UIButton().then {
        $0.setImage(ImdangImages.Image(resource: .backButton), for: .normal)
        $0.isHidden = true
    }
    
    let navigationViewBottomShadow = UIView().then {
        $0.backgroundColor = .grayScale100
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configCustomNavigationBar()
        hideKeyboardwhenTappedAround()
        bindAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    private func configCustomNavigationBar() {
        let topPadding = UIDevice.current.haveTouchId ? 34 : 64
        [customBackButton, leftNaviItemView].forEach {
            leftNavigtaionView.addArrangedSubview($0)
        }
        
        [rightNaviItemView].forEach {
            rightNavigtaionView.addArrangedSubview($0)
        }
        
        [leftNavigtaionView, rightNavigtaionView, navigationViewBottomShadow].forEach {
            view.addSubview($0)
        }
        
        leftNavigtaionView.snp.makeConstraints {
            $0.width.equalTo(view.frame.width / 2)
            $0.top.equalToSuperview().offset(topPadding)
            $0.leading.equalToSuperview().offset(20)
        }
        
        rightNavigtaionView.snp.makeConstraints {
            $0.width.equalTo(view.frame.width / 2)
            $0.top.equalToSuperview().offset(topPadding)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        leftNaviItemView.snp.makeConstraints {
            $0.height.equalTo(34)
            $0.centerY.equalToSuperview()
        }
        
        rightNaviItemView.snp.makeConstraints {
            $0.height.equalTo(34)
            $0.centerY.equalToSuperview()
        }
        
        navigationViewBottomShadow.snp.makeConstraints {
            $0.top.equalToSuperview().offset(UIDevice.current.haveTouchId ? 86 : 116)
            $0.height.equalTo(1)
            $0.horizontalEdges.equalToSuperview()
        }
        
        customBackButton.snp.makeConstraints {
            $0.width.equalTo(20)
            $0.height.equalTo(34)
            $0.centerY.equalTo(leftNaviItemView.snp.centerY)
            $0.leading.equalToSuperview()
        }
    }
    
    private func bindAction() {
        customBackButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension BaseViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController?.viewControllers.count ?? 0 > 1
    }
}
