//
//  PaddingLabel.swift
//  imdang
//
//  Created by 임대진 on 11/26/24.
//

import UIKit

class PaddingLabel: UILabel {
    // 피그마는 UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)가 맞는데 iOS 라벨 Text 상하 기준점이 달라서 5.5 해야 맞는듯
    var padding = UIEdgeInsets(top: 5.5, left: 8, bottom: 5.5, right: 8)

    convenience init(padding: UIEdgeInsets) {
           self.init()
           self.padding = padding
       }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override var intrinsicContentSize: CGSize {
         var contentSize = super.intrinsicContentSize
         contentSize.height += padding.top + padding.bottom
         contentSize.width += padding.left + padding.right

         return contentSize
     }
}
