//
//  AccountInfoAlert.swift
//  MeAmoraNails
//
//  Created by Jason bartley on 11/1/24.
//

import Foundation
import SwiftUI

struct AccountInfoAlertItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let dismissbutton: Alert.Button
}

struct AccountInfoAlertContext {
    static let invalidEmail = AccountInfoAlertItem(title: "Invalid email", message: "Please enter a valid email.", dismissbutton: .default(Text("ok")))
    
    static let invalidFields = AccountInfoAlertItem(title: "Not all fields filled out", message: "Please fill out all fields.", dismissbutton: .default(Text("ok")))
    
    static let unableToSave = AccountInfoAlertItem(title: "Something went wrong, we are unable to save information.", message: "Please try again later", dismissbutton: .default(Text("ok")))
    
    static let SuccessfulSave = AccountInfoAlertItem(title: "All infomation saved!", message: "", dismissbutton: .default(Text("ok")))

}
