//
//  Storyboard.swift
//  QooperChat
//
//  Created by Melih Buyukbayram on 1.02.2020.
//  Copyright © 2020 Melih Buyukbayram. All rights reserved.
//

import UIKit

protocol StringConvertible {
    var rawValue: String {get}
}

protocol Instantiable: class {
    static var storyboardName: StringConvertible {get}
}

extension Instantiable {
    static func instantiateFromStoryboard() -> Self {
        return instantiateFromStoryboardHelper()
    }

    private static func instantiateFromStoryboardHelper<T>() -> T {
        let identifier = String(describing: self)
        let storyboard = UIStoryboard(name: storyboardName.rawValue, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
}

//MARK: -

extension String: StringConvertible {
    var rawValue: String {
        return self
    }
}

//MARK: - Storyboard Enum

enum StoryboardName: String, StringConvertible {
    case main = "Main"
}
