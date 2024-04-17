//
//  UIView+Extension.swift
//  MovieBase
//
//  Created by Alexander on 28.03.2024.
//

import Foundation
import UIKit

extension UIView {
    func addSubviews(_ view: UIView...) {
        for v in view {
            addSubview(v)
        }
    }
}
