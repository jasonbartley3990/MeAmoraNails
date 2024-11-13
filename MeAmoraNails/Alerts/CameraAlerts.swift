//
//  CameraAlerts.swift
//  MeAmoraNails
//
//  Created by Jason bartley on 11/1/24.
//

import Foundation
import SwiftUI

struct CameraAlertItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let dismissbutton: Alert.Button
}

struct CameraAlertContext {
    static let invalidDeviceInput = CameraAlertItem(title: "Invalid device input", message: "Something is wrong with camera, we are unable to capture input", dismissbutton: .default(Text("ok")))
    
    static let uploadError = CameraAlertItem(title: "An issue occured when uploading images!", message: "Please try again later", dismissbutton: .default(Text("ok")))
    
    static let InvalidSizes = CameraAlertItem(title: "Invalid sizes detected!", message: "An issue occured with measurement, please try again.", dismissbutton: .default(Text("Ok")))
    
    static let NoCardDetected = CameraAlertItem(title: "No Card detected!", message: "Either card was not in frame or not properly positioned", dismissbutton: .default(Text("ok")))
    
    static let NoThumbDetected = CameraAlertItem(title: "No thumb detected!", message: "Please position thumb properly", dismissbutton: .default(Text("Ok")))
    
    static let NoHandDetected = CameraAlertItem(title: "No hand detected!", message: "Please position hand properly", dismissbutton: .default(Text("ok")))
    
}
