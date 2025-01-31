//
//  UIViewController +.swift
//  imdang
//
//  Created by daye on 11/17/24.
//

import UIKit
import SnapKit

extension UIViewController {
    func hideKeyboardwhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismisskeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismisskeyboard() {
        view.endEditing(true)
    }
    
    /// 네비게이션 safeArea 까지의 배경색 설정
    func configNavigationBgColor(backgroundColor: UIColor = .systemBackground) {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = backgroundColor
        navigationBarAppearance.shadowColor = .clear // 밑줄 제거
        navigationBarAppearance.shadowImage = UIImage() // 밑줄 제거
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
    }
    
    func configNavigationBackButton() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage()
        
        let customBackImage = ImdangImages.Image(resource: .backButton)
        appearance.setBackIndicatorImage(customBackImage, transitionMaskImage: customBackImage)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = .black
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance    }
    
    func hideNavigationBackButton() {
        self.navigationItem.hidesBackButton = true
    }
    
    func showInsightAlert(text: String, type: AlertType, imageType: AlertImageType = .circleWarning, dimAction: Bool = true, comfrimAction: (() -> Void)? = nil, etcAction: (() -> Void)? = nil) {
        let customAlertViewController = InsightAlertViewController()
        customAlertViewController.config(text: text, type: type, imageType: imageType, dimAction: dimAction)
        customAlertViewController.confirmAction = comfrimAction
        customAlertViewController.cancelAction = etcAction
        customAlertViewController.modalPresentationStyle = .overFullScreen
        customAlertViewController.modalTransitionStyle = .crossDissolve
        self.present(customAlertViewController, animated: true, completion: nil)
    }
    
    func showLogoutAlert(comfrimAction: (() -> Void)? = nil, cancelAction: (() -> Void)? = nil) {
        let customAlertViewController = CommonAlertViewController()
        customAlertViewController.confirmAction = comfrimAction
        customAlertViewController.cancelAction = cancelAction
        customAlertViewController.modalPresentationStyle = .overFullScreen
        customAlertViewController.modalTransitionStyle = .crossDissolve
        self.present(customAlertViewController, animated: true, completion: nil)
    }
}


extension UIViewController {
    func showToast(message: String, duration: TimeInterval = 2.0) {
        let toastLabel = UILabel().then {
            $0.text = message
            $0.textColor = .white
            $0.backgroundColor = .grayScale800
            $0.textAlignment = .center
            $0.font = .pretenSemiBold(18)
            $0.numberOfLines = 0
            $0.alpha = 0.0
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }
        
        self.view.addSubview(toastLabel)
        toastLabel.snp.makeConstraints{
            $0.bottom.equalToSuperview().offset(-108)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            toastLabel.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: duration, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }) { _ in
                toastLabel.removeFromSuperview()
            }
        }
    }
}
