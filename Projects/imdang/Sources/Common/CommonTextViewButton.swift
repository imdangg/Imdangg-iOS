//
//  CommonTextViewButton.swift
//  imdang
//
//  Created by 임대진 on 1/5/25.
//

import UIKit
import Then
import SnapKit


 /*
  ex)
 class viewController: UIViewController {
     let textView = CommonTextViewButton(title: "")
     
     override func viewDidLoad() {
         textView.delegate = self
     }
 }

 extension viewController: CustomTextViewDelegate {
     func customTextViewDidTap(_ CommonTextViewButton: CommonTextViewButton) {
         // 클릭시 작동될 로직
     }
 }
*/

protocol CustomTextViewDelegate: AnyObject {
    func customTextViewDidTap(_ commonTextView: CommonTextViewButton)
}

class CommonTextViewButton: UIView {
    weak var delegate: CustomTextViewDelegate?
    
    let titleLabel = UILabel().then {
        $0.font = .pretenSemiBold(14)
        $0.textColor = .grayScale700
    }
    
    private let checkIcon = UIImageView().then {
        $0.image = ImdangImages.Image(resource: .circleCheck)
    }
    
    private let textCountstackView = UIStackView().then {
        $0.spacing = 2
        $0.alignment = .trailing
    }
    
    private let textCountLabel = UILabel().then {
        $0.text = "최소30자-최대200자"
        $0.font = .pretenMedium(12)
        $0.textColor = .grayScale500
    }
    
    private var currentTextCountLabel = UILabel().then {
        $0.font = .pretenMedium(12)
        $0.textColor = .mainOrange500
    }
    
    
    private let textFieldBackground = UIView().then {
        $0.backgroundColor = .white
        
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.grayScale100.cgColor
        $0.layer.cornerRadius = 8
    }
    
    private let textView = UITextView().then {
        $0.font = .pretenMedium(16)
        $0.textColor = .grayScale900
        $0.autocapitalizationType = .none // 자동 대문자
        $0.autocorrectionType = .no // 자동 수정
        $0.isScrollEnabled = true  // 스크롤 여부
        $0.isEditable = false // 수정 여부
        $0.isSelectable = false // 텍스트 선택
        $0.backgroundColor = .white
    }
    
    var text: String = "" {
        didSet {
            textView.text = text
            placeholderLabel.isHidden = !text.isEmpty
            
            if !self.text.isEmpty {
                currentTextCountLabel.text = "(\(self.text.count)/200)"
                textCountstackView.addArrangedSubview(currentTextCountLabel)
                checkIcon.isHidden = false
            } else {
                currentTextCountLabel.removeFromSuperview()
                checkIcon.isHidden = true
            }
        }
    }
    
    private let placeholderLabel = UILabel().then {
        $0.textColor = .grayScale400
        $0.font = .pretenMedium(16)
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
    }
    
    init(frame: CGRect = .zero, title: String, textCountLabel: String? = "최소30자-최대200자", text: String? = "", placeHolder: String? = "") {
        super.init(frame: frame)
        
        if let textCountLabel = textCountLabel {
            self.textCountLabel.text = textCountLabel
        }
        
        self.titleLabel.text = title
        self.text = text ?? ""
        self.placeholderLabel.text = placeHolder ?? ""
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        textView.addGestureRecognizer(tapGesture)
        
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        textCountstackView.addArrangedSubview(textCountLabel)
        [titleLabel, textCountstackView, textFieldBackground, textView, placeholderLabel, checkIcon].forEach { addSubview($0) }
    }
    
    private func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
        
        textCountstackView.snp.remakeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-20)
        }

        textFieldBackground.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(180)
        }
        
        textView.snp.makeConstraints {
            $0.edges.equalTo(textFieldBackground).inset(16)
        }
        
        placeholderLabel.snp.makeConstraints {
            $0.top.equalTo(textFieldBackground).offset(16)
            $0.horizontalEdges.equalTo(textFieldBackground).inset(16)
        }
        
        checkIcon.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.leading.equalTo(titleLabel.snp.trailing).offset(4)
            $0.height.width.equalTo(20)
        }
    }
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        delegate?.customTextViewDidTap(self)
    }
}
