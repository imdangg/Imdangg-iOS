//
//  UserInfoEntryViewController.swift
//  imdang
//
//  Created by daye on 11/14/24.
//


import UIKit
import RxSwift
import RxCocoa
import SnapKit
import ReactorKit
import Then

class UserInfoEntryViewController: UIViewController, View {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    init(reactor: UserInfoEntryReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var mainTitle = UILabel().then {
        $0.text = "기본정보입력"
        $0.font = .pretenExtraBold(26)
        $0.textColor = UIColor.grayScale900
    }
    
    private var subTitle = UILabel().then {
        $0.text = "추후 진행할 이벤트를 위해 조사하고 있어요.\n개인정보는 유출되지 않으니 걱정 마세요"
        $0.numberOfLines = 2
        $0.font = .pretenMedium(16)
        $0.textColor = UIColor.grayScale700
    }
    
    private var nicknameHeaderView = UserInfoEntryHeaderView()
   

    private var submitButton = CommonButton()
     
    
    private lazy var stackView = UIStackView().then {
        $0.alignment = .center
        [mainTitle, subTitle, nicknameHeaderView, submitButton].forEach { view.addSubview($0) }
    }
    
   override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.grayScale25
        view.addSubview(stackView)
       
        setup()
    }

    func setup() {
        attriubute()
        layout()
    }
    
    func attriubute(){
        nicknameHeaderView.setTitle("닉네임")
        
    }
    
    func layout(){
        mainTitle.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.top)
            $0.leading.equalTo(stackView.snp.leading)
        }
        
        subTitle.snp.makeConstraints {
            $0.top.equalTo(mainTitle.snp.bottom).offset(16)
            $0.leading.equalTo(stackView.snp.leading)
        }
        
        nicknameHeaderView.snp.makeConstraints {
            $0.top.equalTo(subTitle.snp.bottom).offset(44)
            $0.horizontalEdges.equalTo(stackView.snp.horizontalEdges)
        }
        
        submitButton.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.horizontalEdges.equalTo(stackView.snp.horizontalEdges)
            $0.bottom.equalTo(stackView.snp.bottom)
        }
        
        stackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(110)
            $0.bottom.equalToSuperview().inset(40)
        }
    }
    
    func bind(reactor: UserInfoEntryReactor) {
  
        //nicknameHeader
        Observable.just("에러가 낫습니다.")
            .bind(to: nicknameHeaderView.rx.textFieldErrorMessage)
            .disposed(by: disposeBag)


        Observable.just(.done)
            .bind(to: nicknameHeaderView.rx.textFieldState)
            .disposed(by: disposeBag)
        
        
        
        // submitButton
        submitButton.rx.tap
            .map{ Reactor.Action.submitButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
   
        Observable.just("다음") //나중에 필요할까봐 Observable.
            .bind(to: submitButton.rx.commonButtonTitle)
            .disposed(by: disposeBag)


        Observable.just(.disabled)
            .bind(to: submitButton.rx.commonButtonState)
            .disposed(by: disposeBag)
    }
    
}
//
//extension UserInfoEntryViewController: UITextFieldDelegate {
//    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        let animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut) {
//            textField.layer.borderWidth = 1
//            textField.layer.borderColor = UIColor.mainOrange500.cgColor
//            textField.layoutIfNeeded()
//        }
//        
//        animator.startAnimation()
//    }
//    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        let animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut) {
//            textField.layer.borderWidth = 1
//            textField.layer.borderColor = UIColor.grayScale100.cgColor
//            textField.layoutIfNeeded()
//        }
//        
//        animator.startAnimation()
//    }
//    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        
//        if nicknameTextField == self.nicknameTextField {
//            self.bitthTextField.becomeFirstResponder()
//        }
//        
//        textField.resignFirstResponder()
//        return true
//    }
//}
