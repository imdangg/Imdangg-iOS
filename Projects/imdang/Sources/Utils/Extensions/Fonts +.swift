//
//  Fonts +.swift
//  imdang
//
//  Created by 임대진 on 11/12/24.
//

import UIKit

extension UIFont {
    /// Weight 100
    static func pretenThin(_ size: CGFloat) -> UIFont {
        return ImdangFontFamily.PretendardVariable.thin.font(size: size)
    }
    /// Weight 200
    static func pretenExtraLight(_ size: CGFloat) -> UIFont {
        return ImdangFontFamily.PretendardVariable.extraLight.font(size: size)
    }
    /// Weight 300
    static func pretenLight(_ size: CGFloat) -> UIFont {
        return ImdangFontFamily.PretendardVariable.light.font(size: size)
    }
    /// Weight 400
    static func pretenRegular(_ size: CGFloat) -> UIFont {
        return ImdangFontFamily.PretendardVariable.regular.font(size: size)
    }
    /// Weight 500
    static func pretenMedium(_ size: CGFloat) -> UIFont {
        return ImdangFontFamily.PretendardVariable.medium.font(size: size)
    }
    /// Weight 600
    static func pretenSemiBold(_ size: CGFloat) -> UIFont {
        return ImdangFontFamily.PretendardVariable.semiBold.font(size: size)
    }
    /// Weight 700
    static func pretenBold(_ size: CGFloat) -> UIFont {
        return ImdangFontFamily.PretendardVariable.bold.font(size: size)
    }
    /// Weight 800
    static func pretenExtraBold(_ size: CGFloat) -> UIFont {
        return ImdangFontFamily.PretendardVariable.extraBold.font(size: size)
    }
    /// Weight 900
    static func pretenBlack(_ size: CGFloat) -> UIFont {
        return ImdangFontFamily.PretendardVariable.black.font(size: size)
    }
}

