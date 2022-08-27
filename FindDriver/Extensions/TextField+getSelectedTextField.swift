//
//  TextField+getSelectedTextField.swift
//  FindDriver
//
//  Created by Rain Moustfa on 27/08/2022.
//

import Foundation
import UIKit

extension UIView {
func getSelectedTextField() -> UITextField? {

    let totalTextFields = getTextFieldsInView(view: self)

    for textField in totalTextFields{
        if textField.isFirstResponder{
            return textField
        }
    }

    return nil

}

func getTextFieldsInView(view: UIView) -> [UITextField] {

    var totalTextFields = [UITextField]()

    for subview in view.subviews as [UIView] {
        if let textField = subview as? UITextField {
            totalTextFields += [textField]
        } else {
            totalTextFields += getTextFieldsInView(view: subview)
        }
    }

    return totalTextFields
}}
