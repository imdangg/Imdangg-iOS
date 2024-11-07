//
//  FontUtility.swift
//  Imdangg
//
//  Created by 임대진 on 11/3/24.
//

import UIKit

final class FontUtility {
    enum PretendardVariable: String {
        case regular = "PretendardVariable-Regular"
        case thin = "PretendardVariable-Thin"
        case extraLight = "PretendardVariable-ExtraLight"
        case light = "PretendardVariable-Light"
        case medium = "PretendardVariable-Medium"
        case semiBold = "PretendardVariable-SemiBold"
        case bold = "PretendardVariable-Bold"
        case extraBold = "PretendardVariable-ExtraBold"
        case black = "PretendardVariable-Black"
        
        func font(size: CGFloat) -> UIFont? {
            return UIFont(name: self.rawValue, size: size)
        }
    }
    
    static func getFont(type: PretendardVariable, size: CGFloat) -> UIFont? {
        return type.font(size: size)
    }
}
