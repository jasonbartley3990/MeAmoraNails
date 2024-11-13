//
//  NailCameraViewModel.swift
//  MeAmoraNails
//
//  Created by Jason bartley on 11/1/24.
//

import Foundation
import UIKit
import SwiftUI

enum nailSelection {
    case rightHand
    case rightThumb
    case leftHand
    case leftThumb
}

final class NailCameraViewModel: ObservableObject{
    @Published var alertItem: CameraAlertItem?
    
    @Published var showBadCameraPopUp: Bool = false
    
    @Published var showUnableToUploadImagesPopUp: Bool = false
    
    @Published var currentNailSelected: nailSelection = .leftHand {
        didSet {
            didChangeHand()
        }
    }
    
    @Published var currentNailTitle: String = "Left four fingers"
    
    @Published var currentStep: Int = 1
    
    @Published var capturedImage: UIImage?
    
    @Published var measureOthers: Bool = false
    
    @Published var showOptionMenu: Bool = true
    
    @Published var currentSubmissionPhoto: UIImage? {
        didSet {
            guard let width = currentSubmissionPhoto?.size.width else {return}
            guard let height = currentSubmissionPhoto?.size.height else {return}
            
            let proportionSize: Double = height / width
            self.proportion = proportionSize
            print("proportion: \(proportion)")
        }
    }
    
    @Published var proportion: Double?
    
    @Published var showSubmissionImage: Bool = false
    
    @Published var nextUpText: String = "Next: left thumb!"
    
    @Published var disableCaptureButton: Bool = false
    
    @Published var isFlashOn: Bool = false
    
    @Published var isGyroOn: Bool = true
    
    @Published var autoDetectMessage: String = "Initializing..."
    
    @Published var didSnapPhoto: Bool = false
    
    @Published var isShowingOnboarding: Bool = true
    
    @Published var isShowingFingerGuideline = true
    
    @Published var isShowingThumbGuideline = false
   
    @Published var isShowingCameraGuideline: Bool = false

    @Published var measurementIdObject: MeasurementIdResponse?
    
    @Published var isShowingLoadingView: Bool = false
    
    @Published var resultsDidComeBack: Bool = false
    
    @Published var showWaitingScreen: Bool = false
    
    @Published var currentResponse: NewNailMeasurementResponse?
    
    @Published var isShowingHandInformationScreen: Bool = false
    
    @Published var isShowingThumbInformationScreen: Bool = false
    
    @Published var loadingBarSize: Double = 45.0
    
    @Published var isCardDetected: Bool = true
    
    @Published var isHandDetected: Bool = false
    
    @Published var isThumbDetected: Bool = false
    
    @Published var isRetakeMode: Bool = false
    
    @Published var retakeMeasurementId: Int?
    
    @Published var errorText: String = ""
    
    @Published var responseText: String = ""
    
    @Published var showErrorPopUp: Bool = false
    
    @Published var showLevelCardView: Bool = false
    
    @Published var errors: [ErrorHandModel] = []
    
    @Published var currentHandString: String = "hand"
    
    @Published var showProfile: Bool = false
    
    @Published var showAccountInformationScreen: Bool = false
    
    @Published var showPreviousMeasurements: Bool = false
    
    @Published var selfCapture: String = "True" {
        didSet {
            print(selfCapture)
        }
    }
    
    @Published var responsesReturned: Int = 0 {
        didSet {
            if responsesReturned == 4 {
                self.resultsDidComeBack = true
                self.showWaitingScreen = false
                self.responsesReturned = 0
            }
        }
    }
    
    @Published var totalErrors: Int = 0
    
    @Published var errorsReturned: Int = 0 {
        didSet {
            if errorsReturned == totalErrors {
                self.resultsDidComeBack = true
                self.showWaitingScreen =  false
                self.errorsReturned = 0
            }
        }
    }
    
    var leftHandPhoto: UIImage?
    var leftThumbPhoto: UIImage?
    var rightHandPhoto: UIImage?
    var rightThumbPhoto: UIImage?
    
    func didChangeHand() {
        if isRetakeMode {
            switch currentNailSelected {
            case .rightHand:
                currentNailTitle = "Right four fingers"
                currentStep = 3
                loadingBarSize = 135.0
                if self.errors.isEmpty {
                    nextUpText = "Next: Submission!"
                } else {
                    nextUpText = "Next finger"
                }
            case .rightThumb:
                currentNailTitle = "Right Thumb"
                currentStep = 4
                loadingBarSize = 180.0
                if self.errors.isEmpty {
                    nextUpText = "Next: Submission!"
                } else {
                    nextUpText = "Next finger"
                }
            case .leftHand:
                currentNailTitle = "Left four fingers"
                currentStep = 1
                loadingBarSize = 45.0
                if self.errors.isEmpty {
                    nextUpText = "Next: submission!"
                } else {
                    nextUpText = "Next finger"
                }
            case .leftThumb:
                currentNailTitle = "Left Thumb"
                currentStep = 2
                loadingBarSize = 90.0
                if self.errors.isEmpty {
                    nextUpText = "Next: submission!"
                } else {
                    nextUpText = "Next finger"
                }
            }
            
        } else {
            switch currentNailSelected {
            case .rightHand:
                currentNailTitle = "Right four fingers"
                currentStep = 3
                loadingBarSize = 135.0
                nextUpText = "Next: right thumb!"
            case .rightThumb:
                currentNailTitle = "Right Thumb"
                currentStep = 4
                loadingBarSize = 180
                nextUpText = "Next: Submission!"
            case .leftHand:
                currentNailTitle = "Left four fingers"
                currentStep = 1
                loadingBarSize = 45.0
                nextUpText = "Next: left thumb!"
            case .leftThumb:
                currentNailTitle = "Left Thumb"
                currentStep = 2
                loadingBarSize = 90.0
                nextUpText = "Next: right hand!"
            }
        }
    }
    
    func didTapNext() {
        if isRetakeMode {
            guard let image = self.currentSubmissionPhoto else {return}
            let resizedImage = image.resize(to: CGSize(width: 3024, height: 4032))
            let imageData = resizedImage.jpegData(compressionQuality: 0.75)
            
            self.errorText = " errors: \(self.errors.count)"
            
            switch currentNailSelected {
            case .rightHand:
                APIServices.shared.currentImagesStagedToSubmit.right_hand = imageData
            case .rightThumb:
                APIServices.shared.currentImagesStagedToSubmit.right_thumb = imageData
            case .leftHand:
                APIServices.shared.currentImagesStagedToSubmit.left_hand = imageData
            case .leftThumb:
                APIServices.shared.currentImagesStagedToSubmit.left_thumb = imageData
            }
            
            switch self.currentNailSelected {
            case .rightHand:
                guard let object = self.measurementIdObject else {return}
                guard let measurementId = object.measurementid else {return}
                
                self.errors = self.errors.filter() { $0.hand != .rightHand}
                
                if self.errors.count == 0 {
                    self.showWaitingScreen = true
                } else {
                    for handError in self.errors {
                        if handError.hand == .rightThumb {
                            self.currentNailSelected = .rightThumb
                            self.currentHandString = "thumb"
                            break
                        }
                    }
                }
                
                APIServices.shared.newNailMeasurement(id: measurementId, nail: .rightHand, selfCapture: self.selfCapture, completion: {
                    [weak self] res, success, err in
                    if success {
                        self?.currentResponse = res
                        self?.errorsReturned += 1
                    } else {
                        print("unsuccessfully able to process photo")
                    }
                })
            case .rightThumb:
                guard let object = self.measurementIdObject else {
                    errorText = "could not get measurement id object"
                    return}
                guard let measurementId = object.measurementid else {
                    errorText = "could not get measurement id"
                    return}
                
                self.errors = self.errors.filter() { $0.hand != .rightThumb}
                
                if self.errors.count == 0 {
                    self.showWaitingScreen = true
                }
                
                APIServices.shared.newNailMeasurement(id: measurementId, nail: .rightThumb, selfCapture: self.selfCapture, completion: {
                    [weak self] res, success, err in
                    if success {
                        self?.currentResponse = res
                        self?.errorsReturned += 1
                    } else {
                        self?.errorText = err ?? "error with something"
                        print("unsuccessfully able to process photo")
                    }
                })
            case .leftHand:
                guard let object = self.measurementIdObject else {
                    self.errorText = "no object"
                    return}
                guard let measurementId = object.measurementid else {
                    //self.errorText = "no id"
                    return}
                
                self.errors = self.errors.filter() { $0.hand != .leftHand}
                
                if self.errors.count == 0 {
                    self.showWaitingScreen = true
                } else {
                    for handError in self.errors {
                        if handError.hand == .leftThumb {
                            self.currentNailSelected = .leftThumb
                            self.errorText = "Going to left thumb"
                            self.currentHandString = "thumb"
                            break
                        } else if handError.hand == .rightHand {
                            self.currentNailSelected = .rightHand
                            self.errorText = "gong to right hand"
                            self.currentHandString = "hand"
                            break
                        } else if handError.hand == .rightThumb {
                            self.errorText = "going to right thumb"
                            self.currentNailSelected = .rightThumb
                            self.currentHandString = "thumb"
                            break
                        }
                    }
                }
                
                APIServices.shared.newNailMeasurement(id: measurementId, nail: .leftHand, selfCapture: self.selfCapture, completion: {
                    [weak self] res, success, err in
                    if success {
                        self?.currentResponse = res
                        self?.errorsReturned += 1
                    } else {
                        self?.errorText = "Unsuccesful photo upload \(err)"
                    }
                    
                })
            case .leftThumb:
                guard let object = self.measurementIdObject else {return}
                guard let measurementId = object.measurementid else {return}
                
                self.errors = self.errors.filter() { $0.hand != .leftThumb}
                
                if self.errors.count == 0 {
                    self.showWaitingScreen = true
                }  else {
                    for handError in self.errors {
                        if handError.hand == .rightHand {
                            self.currentNailSelected = .rightHand
                            self.currentHandString = "hand"
                            break
                        } else if handError.hand == .rightThumb {
                            self.currentNailSelected = .rightThumb
                            self.currentHandString = "thumb"
                            break
                        }
                    }
                }
                APIServices.shared.newNailMeasurement(id: measurementId, nail: .leftThumb, selfCapture: self.selfCapture, completion: {
                    [weak self] res, success, err in
                    if success {
                        self?.currentResponse = res
                        self?.errorsReturned += 1
                    } else {
                        print("unsuccessfully able to process photo")
                    }
                })
            }
    
            return
        } else {
            guard let image = self.currentSubmissionPhoto else {return}
            let resizedImage = image.resize(to: CGSize(width: 3024, height: 4032))
            let imageData = resizedImage.jpegData(compressionQuality: 0.75)
            
            switch currentNailSelected {
            case .rightHand:
                APIServices.shared.currentImagesStagedToSubmit.right_hand = imageData
                self.currentNailSelected = .rightThumb
                self.currentHandString = "thumb"
                processPhotos(nail: .rightHand)
            case .leftThumb:
                APIServices.shared.currentImagesStagedToSubmit.left_thumb = imageData
                self.currentNailSelected = .rightHand
                self.currentHandString = "hand"
                processPhotos(nail: .leftThumb)
            case .leftHand:
                APIServices.shared.currentImagesStagedToSubmit.left_hand = imageData
                self.currentNailSelected = .leftThumb
                self.currentHandString = "thumb"
                processPhotos(nail: .leftHand)
            case .rightThumb:
                APIServices.shared.currentImagesStagedToSubmit.right_thumb = imageData
                self.showWaitingScreen = true
                self.isFlashOn = false
                self.currentNailSelected = .leftHand
                self.currentHandString = "hand"
                processPhotos(nail: .rightThumb)
            }
        }
    }
    
    func processPhotos(nail: nailSelection) {
        switch nail {
        case .rightHand:
            guard let object = self.measurementIdObject else {return}
            guard let measurementId = object.measurementid else {return}
            
            APIServices.shared.newNailMeasurement(id: measurementId, nail: .rightHand, selfCapture: self.selfCapture, completion: {
                [weak self] res, success, err in
                if success {
                    self?.currentResponse = res
                    self?.responsesReturned += 1
                    print("successful image upload")
                } else {
                    print("unsuccessfully able to process photo")
                }
            })
        case .rightThumb:
            errorText = "in right thumb"
            guard let object = self.measurementIdObject else {
                errorText = "could not get measurement id object"
                return}
            guard let measurementId = object.measurementid else {
                errorText = "could not get measurement id"
                return}
            
            APIServices.shared.newNailMeasurement(id: measurementId, nail: .rightThumb, selfCapture: self.selfCapture, completion: {
                [weak self] res, success, err in
                if success {
                    self?.currentResponse = res
                    self?.responsesReturned += 1
                    self?.errorText = "Successful 4 photo upload and id of \(measurementId ?? 0)"
                    self?.resultsDidComeBack = true
                    self?.showWaitingScreen = false
                } else {
                    self?.showWaitingScreen = false
                    self?.errorText = err ?? "error with something"
                    print("unsuccessfully able to process photo")
                }
            })
        case .leftHand:
            if let measurementId = self.measurementIdObject?.measurementid {
                self.errorText = "No new measurement ID created"
                APIServices.shared.newNailMeasurement(id: measurementId, nail: .leftHand, selfCapture: self.selfCapture, completion: {
                    [weak self] res, success, err in
                    if success {
                        self?.currentResponse = res
                        self?.responsesReturned += 1
                        print("Successful image upload")
                    } else {
                        self?.errorText = "Unsuccesful photo upload"
                        print("unsuccessfully able to process photo")
                    }
                })
            } else {
                self.errorText = "Created new measurement ID"
                APIServices.shared.createMeasurementId(completion: {
                    [weak self] object, success, error in
                    if success {
                        self?.errorText = "Made it to success"
                        self?.measurementIdObject = object
                        guard let object = self?.measurementIdObject else {
                            self?.errorText = "no object"
                            return}
                        self?.errorText = "\(object.measurementid) ,, \(object.measurementresultsid)"
                        guard let measurementId = object.measurementid else {
                            //self.errorText = "no id"
                            return}
                        
                        APIServices.shared.newNailMeasurement(id: measurementId, nail: .leftHand, selfCapture: self?.selfCapture ?? "true",  completion: {
                            [weak self] res, success, err in
                            if success {
                                self?.currentResponse = res
                                self?.responsesReturned += 1
                                self?.errorText = "Successful photo upload and id of \(measurementId ?? 0)"
                            } else {
                                self?.errorText = "Unsuccesful photo upload"
                                print("unsuccessfully able to process photo")
                            }
                        })
                        
                    } else {
                        self?.errorText = " new ID \(error)"
                        print("unable to create a new measurement id")
                    }
                })
            }
        case .leftThumb:
            guard let object = self.measurementIdObject else {return}
            guard let measurementId = object.measurementid else {return}
            
            APIServices.shared.newNailMeasurement(id: measurementId, nail: .leftThumb, selfCapture: self.selfCapture, completion: {
                [weak self] res, success, err in
                if success {
                    self?.currentResponse = res
                    self?.responsesReturned += 1
                    self?.errorText = "Successful image upload"
                } else {
                    print("unsuccessfully able to process photo")
                }
            })
        }
    }
    
    private func photosDidThrowError(response: NewNailMeasurementResponse) -> (Bool, String) {
//        guard response.left_hand_processing_issue == nil else {
//            self.resultsViewModel.didThrowError = true
//            self.resultsViewModel.errorHand = .leftHand
//            self.resultsViewModel.errorDescription = viewModel.currentResponse?.left_hand_processing_issue ?? "An error occured."
//            return
//        }
//
//        guard response.right_hand_processing_issue == nil else {
//            self.resultsViewModel.didThrowError = true
//            self.resultsViewModel.errorHand = .rightHand
//            self.resultsViewModel.errorDescription = self.viewModel.currentResponse?.right_hand_processing_issue ?? "An error occured."
//            return
//        }
//
//        guard response.left_thumb_processing_issue == nil else {
//            self.resultsViewModel.didThrowError = true
//            self.resultsViewModel.errorHand = .leftThumb
//            self.resultsViewModel.errorDescription = self.viewModel.currentResponse?.left_thumb_processing_issue ?? "An error occured"
//            return
//        }
//
//        guard response.right_thumb_processing_issue == nil else {
//            self.resultsViewModel.didThrowError = true
//            self.resultsViewModel.errorHand = .rightThumb
//            self.resultsViewModel.errorDescription = self.viewModel.currentResponse?.right_thumb_processing_issue ?? "An error occured"
//            return
//        }
        return (false, "")
    }
}
