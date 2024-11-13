//
//  WaitingScreenViewModel.swift
//  MeAmoraNails
//
//  Created by Jason bartley on 11/1/24.
//

import Foundation
import SwiftUI

enum waitingStage {
    case one
    case two
    case three
    case four
    case five
}

struct WaitingScreenStageItem: Identifiable {
    let id = UUID()
    let image: String
    let message: String
    let secondMessage: String
    let loadingBarSize: CGFloat
}

struct WaitingScreenContext {
    static let StageOneContent = WaitingScreenStageItem(image: "WaitingPageImage1", message: "This usually takes less than two minutes.", secondMessage: "(it’s enough time to grab a coffee, sip some tea, or look up some inspos...)", loadingBarSize: 50)
    
    static let StageTwoContent = WaitingScreenStageItem(image: "WaitingPageImage2", message: "So, about those 5-odd years you've been painting your nails…", secondMessage: "(we’re not judging, just curious ✨)", loadingBarSize: 100)
    
    static let StageThreeContent = WaitingScreenStageItem(image: "WaitingPageImage3", message: "this will be you: 👁👄👁🤳 💅✨", secondMessage: "", loadingBarSize: 150)
    
    static let StageFourContent = WaitingScreenStageItem(image: "WaitingPageImage4", message: "Double checking...", secondMessage: "(we don’t like making mistakes.)", loadingBarSize: 200)
    
    static let StageFiveContent = WaitingScreenStageItem(image: "WaitingPageImage5", message: "Aaaand we’re done. Let’s take a peek 👀", secondMessage: "", loadingBarSize: 250)
}

final class WaitingScreenViewModel: ObservableObject {
    
    @Published var currentStage: waitingStage = .one {
        didSet {
            switch currentStage {
            case .one:
                currentContext = WaitingScreenContext.StageOneContent
            case .two:
                currentContext = WaitingScreenContext.StageTwoContent
            case .three:
                currentContext = WaitingScreenContext.StageThreeContent
            case .four:
                currentContext = WaitingScreenContext.StageFourContent
            case .five:
                currentContext = WaitingScreenContext.StageFiveContent
            }
        }
    }
    
    @Published var currentContext: WaitingScreenStageItem = WaitingScreenContext.StageOneContent
    
    @Published var slowInternetDetected: Bool = false
    
}
    
