//
//  ConstraintMaker +.swift
//  imdang
//
//  Created by 임대진 on 12/21/24.
//

import SnapKit
import UIKit

extension ConstraintMaker {
    /// 네비게이션 바 하단에 top 고정
    @discardableResult
    func topEqualToNavigationBottom(vc: UIViewController) -> ConstraintMakerEditable {
        if let baseVC = vc as? BaseViewController {
            return self.top.equalTo(baseVC.navigationViewBottomShadow.snp.bottom)
        } else {
            print("⚠️ BaseViewController not found")
            return self.top.equalToSuperview()
        }
    }
}
