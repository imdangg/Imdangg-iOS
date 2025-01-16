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

final class UserInfoEntryViewController: UIViewController, View {
    
    var disposeBag: DisposeBag = DisposeBag()
    private let joinService = ServerJoinService()
    
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
    
    //nickname
    private var nicknameHeaderView = TextFieldHeaderView(title: "닉네임", isEssential: false, descriptionText: "최소 2자-최대10자", limitNumber: 10)
    private var nicknameTextField = CommomTextField(placeholderText: "임당이", textfieldType: .namePhonePad)
    private var niknameFooterView = TextFieldFooterView()
    
    //birth
    private var birthHeaderView = TextFieldHeaderView(title: "생년월일", isEssential: false)
    private var birthTextField = CommomTextField(placeholderText: "2000.01.01", textfieldType: .decimalPad)
    private var birthFooterView = TextFieldFooterView()
    
    //gender
    private var genderHeaderView = TextFieldHeaderView(title: "성별", isEssential: false)
    private var selectMaleButton = CommonButton(title: "남자", initialButtonType: .unselectedBorderStyle)
    private var selectFemaleButton = CommonButton(title: "여자", initialButtonType: .unselectedBorderStyle)
    
    //button
    private var submitButton = CommonButton(title: "다음", initialButtonType: .disabled)
    
    private lazy var stackView = UIStackView().then {
        $0.isUserInteractionEnabled = false
        [mainTitle, subTitle, nicknameHeaderView, nicknameTextField, niknameFooterView, birthHeaderView, birthTextField, birthFooterView, genderHeaderView, selectMaleButton, selectFemaleButton, submitButton].forEach { view.addSubview($0) }
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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
        
        niknameFooterView.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(8)
            $0.height.equalTo(17)
            $0.horizontalEdges.equalTo(stackView.snp.horizontalEdges)
        }
        
        birthHeaderView.snp.makeConstraints {
            $0.top.equalTo(niknameFooterView.snp.bottom).offset(24)
            $0.height.equalTo(20)
            $0.horizontalEdges.equalTo(stackView.snp.horizontalEdges)
        }
        
        birthTextField.snp.makeConstraints {
            $0.top.equalTo(birthHeaderView.snp.bottom).offset(8)
            $0.height.equalTo(52)
            $0.horizontalEdges.equalTo(stackView.snp.horizontalEdges)
        }
        
        birthFooterView.snp.makeConstraints {
            $0.top.equalTo(birthTextField.snp.bottom).offset(8)
            $0.height.equalTo(17)
            $0.horizontalEdges.equalTo(stackView.snp.horizontalEdges)
        }
        
        genderHeaderView.snp.makeConstraints {
            $0.top.equalTo(birthFooterView.snp.bottom).offset(24)
            $0.height.equalTo(20)
            $0.horizontalEdges.equalTo(stackView.snp.horizontalEdges)
        }
        
        selectMaleButton.snp.makeConstraints {
            $0.top.equalTo(genderHeaderView.snp.bottom).offset(8)
            $0.height.equalTo(52)
            $0.leading.equalTo(stackView.snp.leading)
            $0.width.equalTo(selectFemaleButton)
        }
        
        selectFemaleButton.snp.makeConstraints {
            $0.top.equalTo(genderHeaderView.snp.bottom).offset(8)
            $0.leading.equalTo(selectMaleButton.snp.trailing).offset(8)
            $0.height.equalTo(52)
            $0.trailing.equalTo(stackView.snp.trailing)
            $0.width.equalTo(selectMaleButton)
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
        nicknameTextField.rx.controlEvent(.primaryActionTriggered)
            .subscribe(onNext: {[weak self] in self?.birthTextField.becomeFirstResponder()})
            .disposed(by: disposeBag)
        
        nicknameTextField.rx.controlEvent([.editingDidBegin])
            .asDriver()
            .map { Reactor.Action.changeNicknameTextFieldState(.editing) }
            .drive(reactor.action)
            .disposed(by: disposeBag)
        
        
        nicknameTextField.rx.controlEvent([.editingDidEnd])
            .asDriver()
            .map { [weak self] in

                // 닉네임 미입력 오류 처리
                guard let text = self?.nicknameTextField.text, !text.isEmpty else {
                    self?.niknameFooterView.rx.textFieldErrorMessage.onNext("닉네임을 입력해주세요.")
                    return .changeNicknameTextFieldState(.error)
                }
                
                // 닉네임 글자 수 오류 처리
                guard text.count >= 2 && text.count <= 10 else {
                    self?.niknameFooterView.rx.textFieldErrorMessage.onNext("2자~10자로 입력해주세요.")
                    return .changeNicknameTextFieldState(.error)
                }
                
                // 닉네임 입력 완료 상태
                return .changeNicknameTextFieldState(.done)
            }
            .drive(reactor.action) // Reactor로 Action 전달
            .disposed(by: disposeBag)


        nicknameTextField.rx.text
            .orEmpty
            .bind { [weak self] text in
                self?.nicknameHeaderView.setTextNumber(text.count)
            }
            .disposed(by: disposeBag)
        
        nicknameTextField.isClearButtonTapped
            .asDriver(onErrorJustReturn: false)
            .filter { $0 }
            .map { [weak self] _ in
                self?.nicknameHeaderView.setTextNumber(0)
                self?.nicknameTextField.isClearButtonTapped.onNext(false)
                return Reactor.Action.changeNicknameTextFieldState(.normal)
            }
            .drive(reactor.action)
            .disposed(by: disposeBag)
        
        
        // birth
        birthTextField.rx.controlEvent(.primaryActionTriggered)
            .subscribe(onNext: {[weak self] in self?.birthTextField.resignFirstResponder()})
            .disposed(by: disposeBag)
        
        birthTextField.rx.controlEvent([.editingDidBegin])
            .asDriver()
            .map { Reactor.Action.changeBirthTextFieldState(.editing) }
            .drive(reactor.action)
            .disposed(by: disposeBag)
        
        birthTextField.rx.controlEvent([.editingDidEnd])
            .asDriver()
            .map { [weak self] in
                
                // 미입력 오류
                guard let text = self?.birthTextField.text, !text.isEmpty else {
                    self?.birthFooterView.rx.textFieldErrorMessage.onNext("생년월일을 입력해주세요.")
                    return Reactor.Action.changeBirthTextFieldState(.error)
                }
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy.MM.dd"
                
                // 잘못된 날짜 형식 or 다른게 들어갔을때
                if dateFormatter.date(from: text) == nil {
                    self?.birthFooterView.rx.textFieldErrorMessage.onNext("잘못된 생년월일을 입력하셨어요.")
                    return Reactor.Action.changeBirthTextFieldState(.error)
                }
                
                // 과거 또는 오늘 날짜 체크
                let currentDate = Date()
                if let inputDate = dateFormatter.date(from: text), inputDate > currentDate {
                    self?.birthFooterView.rx.textFieldErrorMessage.onNext("과거 또는 오늘 날짜를 입력해주세요.")
                    return Reactor.Action.changeBirthTextFieldState(.error)
                }
                
                // TODO: 유효한 날짜 추가 필요해보임
                return Reactor.Action.changeBirthTextFieldState(.done)
            }
            .drive(reactor.action)
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
        selectMaleButton.rx.tap
            .map{ Reactor.Action.tapGenderButton(.male)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        selectFemaleButton.rx.tap
            .map{ Reactor.Action.tapGenderButton(.female)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        submitButton.rx.tap.subscribe(onNext: { [self] in
            guard let nickname = nicknameTextField.text, !nickname.isEmpty else {
                print("nickname empty")
                return
            }
            guard let birthDate = birthTextField.text, !birthDate.isEmpty else {
                print("birthDate empty")
                return
            }
                
            joinService.joinImdang(nickname: nickname, birthDate: birthDate, gender: reactor.currentState.selectedGender)
                    .subscribe { success in
                        if success {
                            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootView(TabBarController(), animated: true)
                        } else {
                            print("join failed")
                        }
                    }
                    .disposed(by: disposeBag)
            
//                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootView(TabBarController(), animated: true)
        }).disposed(by: disposeBag)
        
        bindingKeyboard()
        
        reactor.state
            .map { $0.nicknameTextFieldState }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] state in
                self?.nicknameHeaderView.rx.textFieldState.onNext(state)
                self?.nicknameTextField.setState(state)
                self?.niknameFooterView.setState(state)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.birthTextFieldState }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] state in
                self?.birthHeaderView.rx.textFieldState.onNext(state)
                self?.birthTextField.setState(state)
                self?.birthFooterView.setState(state)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map {$0.selectedGender}
            .distinctUntilChanged()
            .filter { $0 != .none }
            .subscribe(onNext: { [weak self] state in
                self?.selectMaleButton.rx.commonButtonState.onNext(state == .male ? .selectedBorderStyle : .unselectedBorderStyle)
                self?.selectFemaleButton.rx.commonButtonState.onNext(state == .female ? .selectedBorderStyle : .unselectedBorderStyle)
                self?.genderHeaderView.rx.textFieldState.onNext(.done)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { state in
                let isNicknameValid = (state.nicknameTextFieldState == .done)
                let isBirthValid = (state.birthTextFieldState == .done)
                let isGenderSelected = (state.selectedGender != .none)
                
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
    
    private func formatText(_ text: String) -> String {
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

// Keyboard event
extension UserInfoEntryViewController {
    
    func keyboardHeight() -> Observable<CGFloat> {
        return Observable
            .from([
                NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
                    .map { notification -> CGFloat in
                        (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
                    },
                NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
                    .map { _ -> CGFloat in
                        0
                    }
            ])
            .merge()
    }
    
    func bindingKeyboard() {
        keyboardHeight()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { keyboardHeight in
                UIView.animate(withDuration: 0.1) {
                    let safeAreaBottom = self.view.safeAreaInsets.bottom
                    let height = keyboardHeight > 0.0 ? (keyboardHeight - safeAreaBottom) : safeAreaBottom
                    self.updateNextBtnBottom(-height, keyboardHeight)
                    self.view.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    func updateNextBtnBottom(_ offset: CGFloat, _ keyboardHeight: CGFloat){
        self.submitButton.snp.remakeConstraints {
            if keyboardHeight > 0.0 {
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(offset)
            } else {
                $0.bottom.equalTo(stackView.snp.bottom)
            }
            $0.horizontalEdges.equalTo(keyboardHeight > 0.0 ? 0 : stackView.snp.horizontalEdges)
            $0.height.equalTo(56)
        }
    }
}
