//
//  AccountCreationAlert.swift
//  MeAmoraNails
//
//  Created by Jason bartley on 11/1/24.
//

import Foundation
import SwiftUI

struct AccountCreationAlertItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let dismissbutton: Alert.Button
}

struct AccountCreationAlertContext {
    static let invalidEmail = AccountCreationAlertItem(title: "Invalid email", message: "Please enter a valid email.", dismissbutton: .default(Text("ok")))
    
    static let invalidFields = AccountCreationAlertItem(title: "Not all fields filled out", message: "Please fill out all fields.", dismissbutton: .default(Text("ok")))
    
    static let passwordMustHaveANumber = AccountCreationAlertItem(title: "Password must contain a number", message: "Please use a number in password.", dismissbutton: .default(Text("ok")))
    
    static let passwordNotLongEnough = AccountCreationAlertItem(title: "Password must be at least 8 characters long", message: "Please make password long enough.", dismissbutton: .default(Text("ok")))
    
    static let passwordMustHaveAnUppercase = AccountCreationAlertItem(title: "Password must contain an uppercase letter", message: "Please use an uppercase letter.", dismissbutton: .default(Text("ok")))
    
    static let unableToCreateAccount = AccountCreationAlertItem(title: "We are unable to create account", message: "Please try again later.", dismissbutton: .default(Text("ok")))
    
    static let passwordsDoNotMatch = AccountCreationAlertItem(title: "Passwords do not match", message: "Please confirm password", dismissbutton: .default(Text("ok")))
    
    static let noCharacterChoosen = AccountCreationAlertItem(title: "No character choosen", message: "Please choose a character to create account", dismissbutton: .default(Text("ok")))

}
