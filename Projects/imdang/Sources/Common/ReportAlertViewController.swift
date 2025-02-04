//
//  ReportAlertViewController.swift
//  imdang
//
//  Created by 임대진 on 2/3/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class ReportAlertViewController: UIViewController {
    var confirmAction: (() -> Void)?
    var cancelAction: (() -> Void)?
    private let disposeBag = DisposeBag()
    private let dimView = UIButton().then {
        $0.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
    }
    
    private let alertView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 20
    }
    
    private let icon = UIImageView().then {
        $0.image = ImdangImages.Image(resource: .circleWarning)
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .pretenSemiBold(18)
        $0.textColor = .grayScale900
    }
    
    private let descriptionLabel = UILabel().then {
        $0.font = .pretenRegular(16)
        $0.textColor = .grayScale600
        $0.numberOfLines = 0
    }
    
    private let emailLabel = UIButton().then {
        $0.setTitleColor(.mainOrange500, for: .normal)
        $0.titleLabel?.font = .pretenRegular(16)
        $0.setAttributedTitle(NSAttributedString(string: "imdang904@gmail.com", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue]), for: .normal)
    }
    
    private let cancleButton = UIButton().then {
        $0.backgroundColor = .white
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(.grayScale700, for: .normal)
        $0.titleLabel?.font = .pretenSemiBold(16)
        
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(hexCode: "#CBD5E0").cgColor
    }
    
    private let confirmButton = UIButton().then {
        $0.backgroundColor = .mainOrange500
        $0.setTitle("네, 괜찮아요", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .pretenSemiBold(16)
        $0.layer.cornerRadius = 8
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindActions()
    }
    
    private func addSubviews() {
        [icon, titleLabel, descriptionLabel, emailLabel, cancleButton, confirmButton].forEach { alertView.addSubview($0) }
        [dimView, alertView].forEach { view.addSubview($0) }
    }
    
    private func makeConstrints() {
        dimView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        alertView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(335)
        }
        
        icon.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(64)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(icon.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        cancleButton.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(24)
            $0.width.equalTo(137.5)
            $0.height.equalTo(52)
        }
    }
    
    private func bindActions() {
        
        cancleButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
                self?.cancelAction?()
            })
            .disposed(by: disposeBag)
        
        confirmButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
                self?.confirmAction?()
            })
            .disposed(by: disposeBag)
        
        emailLabel.rx.tap
            .subscribe(onNext: { _ in
                if let url = URL(string: "mailto:imdang904@gmail.com") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setConfirmButton(type: AlertType, email: Bool) {
        switch type {
        case .confirmOnly:
            confirmButton.setTitle("확인", for: .normal)
            cancleButton.isHidden = true
            
            if email {
                emailLabel.snp.makeConstraints {
                    $0.top.equalTo(descriptionLabel.snp.bottom).offset(8)
                    $0.centerX.equalToSuperview()
                }
                
                confirmButton.snp.makeConstraints {
                    $0.top.equalTo(emailLabel.snp.bottom).offset(24)
                    $0.bottom.equalToSuperview().inset(24)
                    $0.horizontalEdges.equalToSuperview().inset(24)
                    $0.height.equalTo(52)
                }
            } else {
                confirmButton.snp.makeConstraints {
                    $0.top.equalTo(descriptionLabel.snp.bottom).offset(24)
                    $0.bottom.equalToSuperview().inset(24)
                    $0.horizontalEdges.equalToSuperview().inset(24)
                    $0.height.equalTo(52)
                }
            }
            
        case .cancellable:
            emailLabel.isHidden = true
            confirmButton.setTitle("네, 괜찮아요", for: .normal)
            
            confirmButton.snp.makeConstraints {
                $0.top.equalTo(descriptionLabel.snp.bottom).offset(24)
                $0.trailing.equalToSuperview().offset(-24)
                $0.bottom.equalToSuperview().offset(-24)
                $0.width.equalTo(137.5)
                $0.height.equalTo(52)
            }
        default:
            break
        }
    }
    
    func config(title: String, description: String, email: Bool, highligshtText: String, type: AlertType) {
        addSubviews()
        makeConstrints()
        setConfirmButton(type: type, email: email)
        
        titleLabel.text = title
        
        let attributedString = NSMutableAttributedString(string: description)

        let range = (description as NSString).range(of: highligshtText)
        attributedString.addAttribute(.foregroundColor, value: UIColor.mainOrange500, range: range)
        attributedString.addAttribute(.font, value: UIFont.pretenSemiBold(16), range: range)

        let style = NSMutableParagraphStyle()
        style.maximumLineHeight = 22.4
        style.minimumLineHeight = 22.4

        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: style,
            .baselineOffset: (22.4 - UIFont.pretenRegular(16).lineHeight) / 4
        ]

        attributedString.addAttributes(attributes, range: NSRange(location: 0, length: attributedString.length))

        descriptionLabel.attributedText = attributedString
        descriptionLabel.textAlignment = .center
    }
}
