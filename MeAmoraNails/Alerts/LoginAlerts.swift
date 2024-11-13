//
//  LoginAlerts.swift
//  MeAmoraNails
//
//  Created by Jason bartley on 11/1/24.
//

import Foundation
import SwiftUI

struct LoginAlertItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let dismissbutton: Alert.Button
}

struct LoginAlertContext {
    static let invalidEmail = LoginAlertItem(title: "Invalid email", message: "Please enter a valid email.", dismissbutton: .default(Text("ok")))
    
    static let invalidFields = LoginAlertItem(title: "Not all fields filled out", message: "Please fill out all fields.", dismissbutton: .default(Text("ok")))
    
    static let wrongCredentials = LoginAlertItem(title: "Wrong email or password", message: "Please try again.", dismissbutton: .default(Text("ok")))

    static let somethingWentWrong = LoginAlertItem(title: "Something went wrong", message: "Please try again.", dismissbutton: .default(Text("ok")))
}
