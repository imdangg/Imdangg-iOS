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
   
    private var submitButton = WideButtonView(frame: .zero, title: "완료")
   
    init(controlBy vc: UserInfoEntryViewController) {
        self.vc = vc
        super.init(frame: UIScreen.main.bounds)
        self.backgroundColor = .systemPink
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        addSubview(submitButton)
        attriubute()
        layout()
    }
}

// MARK: - View
private extension UserInfoEntryView {
    func attriubute(){}
    func layout(){

        submitButton.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
}

// MARK: - Rector
extension UserInfoEntryView: View {
    func bind(reactor: UserInfoEntryViewReactor) {

        
        
      
    }
    
}
