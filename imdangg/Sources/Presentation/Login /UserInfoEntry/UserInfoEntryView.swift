//
//  UserInfoEntryView.swift
//  imdangg
//
//  Created by daye on 11/11/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit
import ReactorKit

class UserInfoEntryView: UIView {
    weak var vc: UserInfoEntryViewController?
    var disposeBag: DisposeBag = DisposeBag()
    
    init(controlBy vc: UserInfoEntryViewController) {
        self.vc = vc
        super.init(frame: UIScreen.main.bounds)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        attriubute()
        layout()
    }
}

// MARK: - View
private extension UserInfoEntryView {
    func attriubute(){}
    func layout(){}
}

// MARK: - Rector
extension UserInfoEntryView: View {
    func bind(reactor: UserInfoEntryViewReactor) {
        
    }
}
