//
//  UIButton +.swift
//  imdang
//
//  Created by 임대진 on 1/27/25.
//

import UIKit

extension UIButton {
    func capsulLayer(height: Int) {
        self.layer.cornerRadius = Double(height) / 2
    }
}
