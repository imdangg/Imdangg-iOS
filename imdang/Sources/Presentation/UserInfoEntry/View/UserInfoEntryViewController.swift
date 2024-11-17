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
    
    private var nicknameHeaderView = UserInfoEntryHeaderView(title: "닉네임")
    private var nicknameTextField = CommomTextField(placeholderText: "임당이", textfieldType: .namePhonePad)
    
    private var birthHeaderView = UserInfoEntryHeaderView(title: "생년월일")
    private var birthTextField = CommomTextField(placeholderText: "2000.01.01", textfieldType: .numberPad)
    
    private var genderHeaderView = UserInfoEntryHeaderView(title: "성별")
    private var manButton = CommonButton(title: "남자", initialButtonType: .unselectedBorderStyle)
    private var womanButton = CommonButton(title: "여자", initialButtonType: .unselectedBorderStyle)
    
    private var submitButton = CommonButton(title: "다음", initialButtonType: .disabled)
    
    private lazy var stackView = UIStackView().then {
        $0.isUserInteractionEnabled = false
        [mainTitle, subTitle, nicknameHeaderView, nicknameTextField, birthHeaderView, birthTextField, genderHeaderView, manButton, womanButton, submitButton].forEach { view.addSubview($0) }
    }
    
    init(reactor: UserInfoEntryReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            $0.height.equalTo(20)
            $0.horizontalEdges.equalTo(stackView.snp.horizontalEdges)
        }
        
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(nicknameHeaderView.snp.bottom).offset(8)
            $0.height.equalTo(52)
            $0.horizontalEdges.equalTo(stackView.snp.horizontalEdges)
        }
        
        birthHeaderView.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(32)
            $0.height.equalTo(20)
            $0.horizontalEdges.equalTo(stackView.snp.horizontalEdges)
        }
        
        birthTextField.snp.makeConstraints {
            $0.top.equalTo(birthHeaderView.snp.bottom).offset(8)
            $0.height.equalTo(52)
            $0.horizontalEdges.equalTo(stackView.snp.horizontalEdges)
        }
        
        genderHeaderView.snp.makeConstraints {
            $0.top.equalTo(birthTextField.snp.bottom).offset(32)
            $0.height.equalTo(20)
            $0.horizontalEdges.equalTo(stackView.snp.horizontalEdges)
        }
        
        manButton.snp.makeConstraints {
            $0.top.equalTo(genderHeaderView.snp.bottom).offset(8)
            $0.height.equalTo(52)
            $0.leading.equalTo(stackView.snp.leading)
            $0.width.equalTo(womanButton)
        }
        
        womanButton.snp.makeConstraints {
            $0.top.equalTo(genderHeaderView.snp.bottom).offset(8)
            $0.leading.equalTo(manButton.snp.trailing).offset(8)
            $0.height.equalTo(52)
            $0.trailing.equalTo(stackView.snp.trailing)
            $0.width.equalTo(manButton)
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
  
        //nickname
        Observable.just("에러가 낫습니다.")
            .bind(to: nicknameHeaderView.rx.textFieldErrorMessage)
            .disposed(by: disposeBag)
        
        nicknameTextField.rx.controlEvent(.primaryActionTriggered)
            .subscribe(onNext: {[weak self] in self?.nicknameTextField.resignFirstResponder()})
            .disposed(by: disposeBag)
        
        nicknameTextField.rx.controlEvent([.editingDidBegin])
            .asDriver()
            .map { Reactor.Action.changeNicknameTextFieldState(.editing) }
            .drive(reactor.action)
            .disposed(by: disposeBag)
        
        nicknameTextField.rx.controlEvent([.editingDidEnd])
            .map { [weak self] in
                guard let text = self?.nicknameTextField.text, !text.isEmpty else {
                    self?.nicknameHeaderView.rx.textFieldErrorMessage.onNext("닉네임을 입력해주세요.")
                    return Reactor.Action.changeNicknameTextFieldState(.error)
                }
                return Reactor.Action.changeNicknameTextFieldState(.done)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // birth
        nicknameTextField.rx.controlEvent(.primaryActionTriggered)
            .subscribe(onNext: {[weak self] in self?.birthTextField.resignFirstResponder()})
            .disposed(by: disposeBag)
        
        birthTextField.rx.controlEvent([.editingDidBegin])
            .asDriver()
            .map { Reactor.Action.changeBirthTextFieldState(.editing) }
            .drive(reactor.action)
            .disposed(by: disposeBag)
        
        birthTextField.rx.controlEvent([.editingDidEnd])
            .map { [weak self] in
                guard let text = self?.birthTextField.text, !text.isEmpty else {
                    self?.birthHeaderView.rx.textFieldErrorMessage.onNext("생년월일을 입력해주세요.")
                    return Reactor.Action.changeBirthTextFieldState(.error)
                }
                return Reactor.Action.changeBirthTextFieldState(.done)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        birthTextField.rx.text
            .orEmpty
            .map { text in
                let limitedText = String(text.prefix(10))
                let formattedText = self.formatText(limitedText)
                return formattedText
            }
            .bind(to: birthTextField.rx.text)
            .disposed(by: disposeBag)
        
        
        // gender
        manButton.rx.tap
            .map{ Reactor.Action.tapGenderButton(.man)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        womanButton.rx.tap
            .map{ Reactor.Action.tapGenderButton(.woman)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        // submitButton
//        submitButton.rx.tap
//            .map{ Reactor.Action.submitButtonTapped }
//            .bind(to: reactor.action)
//            .disposed(by: disposeBag)

        reactor.state
            .map { $0.nicknameTextfieldState }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] state in
                self?.nicknameHeaderView.rx.textFieldState.onNext(state) // nicknameHeaderView에 상태 전달
                self?.nicknameTextField.setState(state) // nicknameTextField 상태 업데이트
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map {$0.selectedGender}
            .distinctUntilChanged()
            .filter { $0 != .none }
            .subscribe(onNext: { [weak self] state in
                self?.manButton.rx.commonButtonState.onNext(state == .man ? .selectedBorderStyle : .unselectedBorderStyle)
                self?.womanButton.rx.commonButtonState.onNext(state == .woman ? .selectedBorderStyle : .unselectedBorderStyle)
                self?.genderHeaderView.rx.textFieldState.onNext(.done)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { state in
                let isNicknameValid = state.nicknameTextfieldState == .done
                let isBirthValid = state.bitrhTextFieldState == .done
                let isGenderSelected = state.selectedGender != .none
                
                return isNicknameValid && isBirthValid && isGenderSelected
            }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] isEnableSubmitButton in
                self?.reactor?.action.onNext(.checkEnableSubmitButton(isEnableSubmitButton))
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.submitButtonEnabled }
            .subscribe(onNext: { [weak self] isEnabled in
                self?.submitButton.rx.commonButtonState.onNext(isEnabled ? .enabled : .disabled)
            })
            .disposed(by: disposeBag)
    }
    
    func formatText(_ text: String) -> String {
        var result = text.replacingOccurrences(of: ".", with: "")
        
        if result.count > 4 {
            let index = result.index(result.startIndex, offsetBy: 4)
            result.insert(".", at: index)
        }
        
        if result.count > 7 {
            let index = result.index(result.startIndex, offsetBy: 7)
            result.insert(".", at: index)
        }
        
        return result
    }
    
}
