//
//  UserInfoEntryView.swift
//  imdangg
//
//  Created by daye on 11/11/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import ReactorKit

class UserInfoEntryView: UIView {
    weak var vc: UserInfoEntryViewController?
    
    var disposeBag: DisposeBag = DisposeBag()
   
    private var mainTitle = UILabel().then {
        $0.text = "기본정보입력"
        $0.font = FontUtility.getFont(type: .extraBold, size: 26)
        $0.textColor = UIColor.grayScale900
    }
    
    private var subTitle = UILabel().then {
        $0.text = "추후 진행할 이벤트를 위해 조사하고 있어요.\n개인정보는 유출되지 않으니 걱정 마세요"
        $0.numberOfLines = 2
        $0.font = FontUtility.getFont(type: .medium, size: 16)
        $0.textColor = UIColor.grayScale700
    }
    
    private var nicknameHeader = UserInfoEntryHeaderView(frame: .zero, title: "로그인",
                                                         isVaildState: true,
                                                         errorMessage: "")
    
    private var nicknameTextField = UITextField().then {
        $0.placeholder = "임당이"
        $0.font = FontUtility.getFont(type: .semiBold, size: 16)
        $0.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        $0.leftViewMode = .always
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.grayScale100.cgColor
        $0.textContentType = .name
    }
    
    private var birthHeader = UserInfoEntryHeaderView(frame: .zero,
                                                      title: "생년월일",
                                                      isVaildState: true,
                                                      errorMessage: "")
    
    private var genderButtonView = GenderButtonView(frame: .zero,
                                                    userGender: .none,
                                                    titleGender: .man)
    
    private var submitButton = WideButtonView(frame: .zero,
                                              title: "완료")
    
    
    init(controlBy vc: UserInfoEntryViewController) {
        self.vc = vc
        super.init(frame: UIScreen.main.bounds)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        addSubView()
        attriubute()
        layout()
    }
    
    private func addSubView() {
        [mainTitle, subTitle,].forEach { addSubview($0) }
//        nicknameHeader, nicknameTextField
    }
}

// MARK: - View
private extension UserInfoEntryView {
    func attriubute(){}
    func layout(){
        mainTitle.snp.makeConstraints {
            $0.top.equalToSuperview().inset(110)
            $0.leading.equalToSuperview().inset(20)
        }
        subTitle.snp.makeConstraints {
            $0.top.equalTo(mainTitle.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(20)
        }
//        nicknameHeader.snp.makeConstraints {
//            $0.top.equalTo(subTitle.snp.bottom).offset(44)
//            $0.leading.trailing.equalToSuperview().inset(20)
//        }
//        nicknameTextField.snp.makeConstraints {
//            $0.top.equalTo(nicknameHeader.snp.bottom).offset(8)
//            $0.height.equalTo(52)
//            $0.leading.trailing.equalToSuperview().inset(20)
//        }
    }
}

// MARK: - Rector
extension UserInfoEntryView: View {
    func bind(reactor: UserInfoEntryViewReactor) {

        
        
      
    }
    
}
