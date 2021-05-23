//
//  SegueHandlerType.swift
//  BDDProject
//
//  Created by Julien DAVID on 03/03/2021.
//

import Foundation
import UIKit

protocol SegueHandlerType {

    // `typealias` has been changed to `associatedtype` for Protocols in Swift 3.
    associatedtype SegueIdentifier: RawRepresentable
}

extension SegueHandlerType where Self: UIViewController, SegueIdentifier.RawValue == String {

    // This used to be `performSegueWithIdentifier(...)`.
    func performSegue(withIdentifier identifier: SegueIdentifier, sender: Any?) {
        performSegue(withIdentifier: identifier.rawValue, sender: sender)
    }

    func segueIdentifier(for segue: UIStoryboardSegue) -> SegueIdentifier {
        guard let identifier = segue.identifier, let segueIdentifier = SegueIdentifier(rawValue: identifier) else {
            fatalError("Couldn't handle segue identifier \(String(describing: segue.identifier)) for view controller of type \(type(of: self)).")
        }

        return segueIdentifier
    }
}
