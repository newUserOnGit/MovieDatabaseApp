//
//  Transistion.swift
//  MovieBase
//
//  Created by Alexander on 28.03.2024.
//

import Foundation
import UIKit

public protocol Transition: AnyObject {
    var viewController: UIViewController? { get set }
    
    func open(_ viewController: UIViewController)
    func close(_ viewController: UIViewController, animated: Bool?)
}

