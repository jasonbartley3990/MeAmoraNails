//
//  NailResultsViewModel.swift
//  MeAmoraNails
//
//  Created by Jason bartley on 11/1/24.
//

import Foundation
import SwiftUI

enum HandName {
    case rightThumb
    case leftThumb
    case rightHand
    case leftHand
}

struct ErrorHandModel {
    let hand: HandName
    let errorHand: String
    let errorDescripton: String
}

final class ResultsViewModel: ObservableObject {
    @Published var didThrowError: Bool = false
    
    @Published var errors: [ErrorHandModel] = [] {
        didSet {
            let errorCount = errors.count
            let size = errorCount * 90
            self.errorViewSize = CGFloat(260 + size)
        }
    }
    
    @Published var errorDescription: String = ""
    
    @Published var errorHandText: String = "Right Hand"
    
    @Published var errorViewSize: CGFloat = 330
    
    @Published var leftHandDidThrowError: Bool = false
    
    @Published var leftThumbDidThrowError: Bool = false
    
    @Published var rightHandDidThrowError: Bool = false
    
    @Published var rightThumbDidThrowError: Bool = false
    
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
