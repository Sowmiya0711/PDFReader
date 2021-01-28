//
//  UIViewControlleExtension.swift
//  PdfReader
//
//  Created by CSS on 28/01/21.
//  Copyright © 2021 Sowmiya. All rights reserved.
//

import Foundation
import UIKit

enum Storyboard: String {
    case main = "Main"
}

extension UIViewController {
    
    class func instantiate<T: UIViewController>(appStoryboard: Storyboard) -> T {
        
        let storyboard = UIStoryboard(name: appStoryboard.rawValue, bundle: nil)
        let identifier = String(describing: self)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
}
