//
//  PreviousResultsViewModel.swift
//  MeAmoraNails
//
//  Created by Jason bartley on 11/1/24.
//

import Foundation
import SwiftUI

final class previousResultViewModel: ObservableObject {
    @Published var didThrowError: Bool = false
    
    @Published var errorDescription: String = ""
    
    @Published var errorHandText: String = "Right Hand"
    
    @Published var showMarkMeasurementPopUp: Bool = false
    
    @Published var showDeleteMeasurementPopUp: Bool = false
    
    @Published var showAPIResults: Bool = false
    
    @Published var APIResults: Bool = false
    
    @Published var errorHand: HandName = .leftHand {
        didSet {
            switch errorHand {
            case .rightThumb:
                errorHandText = "Right thumb"
            case .leftThumb:
                errorHandText = "Left thumb"
            case .rightHand:
                errorHandText = "Right hand"
            case .leftHand:
                errorHandText = "Left hand"
            }
        }
    }
    
    static let catchAllError = "An error occured during nail measurement. Please measure again for accurate nail size."
}
