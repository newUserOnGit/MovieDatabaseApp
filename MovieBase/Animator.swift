//
//  Animator.swift
//  MovieBase
//
//  Created by Alexander on 28.03.2024.
//

import Foundation
import UIKit

public protocol Animator: UIViewControllerAnimatedTransitioning {
    var isPresenting: Bool { get set }
}
