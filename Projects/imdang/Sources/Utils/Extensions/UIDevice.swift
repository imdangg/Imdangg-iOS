//
//  UIDevice.swift
//  imdang
//
//  Created by 임대진 on 12/19/24.
//

import UIKit

extension UIDevice {
    /*
     iPhone 6s / 6s Plus
     iPhone SE (1st generation)
     iPhone 7 / 7 Plus
     iPhone 8 / 8 Plus
     터치 아이디 가진 모델
     */
    public var haveTouchId: Bool {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone && (UIScreen.main.bounds.size.height <= 736 && UIScreen.main.bounds.size.width <= 414) {
            return true
        }
        return false
    }
}
