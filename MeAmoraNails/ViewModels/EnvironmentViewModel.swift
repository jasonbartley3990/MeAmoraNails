//
//  EnvironmentViewModel.swift
//  MeAmoraNails
//
//  Created by Jason bartley on 11/1/24.
//

import Foundation
import SwiftUI

enum CharacterSelection {
    case none
    case one
    case two
    case three
    case four
    case five
}

class EnvironmentViewModel: ObservableObject {
    
    @Published var isShowingLaunchScreen: Bool = true
    
    @Published var isShowingTabView: Bool = true
    
    @Published var isSignedIn = false
    
    @Published var userObject: UserObject? {
        didSet {
            self.setAvatarInfo()
        }
    }
    
    //all measurements
    @Published var savedMeasurements: [Measurements] = []
    
    //saved manual measurement
    @Published var savedManualMeasurements: SaveNailImagesResponse?
    
    //success measurements without error
    @Published var successfulMeasurements: [SuccessfulMeasurementsResponseItem] = []
    
    @Published var screenWidth: Double? {
        didSet {
            print("Screen width: \(screenWidth)")
        }
    }
    
    @Published var screenHeight: CGFloat? {
        didSet {
            print("Screen height: \(screenHeight)")
        }
    }
    
    @Published var device: String = "iOS"
    
    @Published var nailSizes: [NailSizeGroupResponse] = []
    
    @Published var sizesReturned: Bool = false
    
    @Published var goToOnboardingScreen: Bool = false
    
    @Published var isHomeSelected: Bool = true
    
    @Published var isShopSelected: Bool = false
    
    @Published var isCustomSelected: Bool = false
    
    @Published var isMeasureSelected: Bool = false
    
    @Published var isProfileSelected: Bool = false
    
    @Published var isTestMode: Bool = true
    
    @Published var allAvatars: [Avatar]? = []
    
    @Published var avatarId: Int?
    
    @Published var avatarName: String?
    
    @Published var avatarImage: String?
    
    @Published var selectedCharacter: CharacterSelection = .none
    
    @Published public var allProducts: [Product] = []
    
    @Published var handPhotosAssetsRecieved: Bool = false
    
    @Published var handPhotoAssets: [HandPhotoModel] = []
    
    @Published var isLogin: Bool = true
    
    func setAvatarInfo() {
        if self.userObject?.avatar_id == 1 {
            self.avatarId = 1
            self.avatarName = "Feminine"
            self.avatarImage = "WaitingPageImage5"
            self.selectedCharacter = .one
        } else if self.userObject?.avatar_id == 2 {
            self.avatarId = 2
            self.avatarName = "Edgy"
            self.avatarImage = "WaitingPageImage1"
            self.selectedCharacter = .two
        } else if self.userObject?.avatar_id == 3 {
            self.avatarId = 3
            self.avatarName = "Humble"
            self.avatarImage = "WaitingPageImage2"
            self.selectedCharacter = .three
        } else if self.userObject?.avatar_id == 4 {
            self.avatarId = 4
            self.avatarName = "Balance"
            self.avatarImage = "WaitingPageImage4"
            self.selectedCharacter = .four
        } else if self.userObject?.avatar_id == 5 {
            self.avatarId = 5
            self.avatarName = "Laidback"
            self.avatarImage = "WaitingPageImage3"
            self.selectedCharacter = .five
        }
        
    }
    
    func checkIfSignedIn() {
        self.device = UIDevice.modelName
        APIServices.shared.device = UIDevice.modelName
        KeyChainManager.shared.logInUser(completion: {
            [weak self] loggedIn, user in
            if loggedIn {
                self?.userObject = user
                self?.isSignedIn = true
                
                APIServices.shared.getPostManualMeasurements(getMeasurements: true, measurements: nil) { [weak self] errorMessage, nailMeasurements in
                    
                    //MARK: come back to this
                        
//                    guard errorMessage == nil else {
//                        self.showErrorMessage(message: errorMessage!)
//                        return
//                    }
//
//                    guard let nailMeasurements = nailMeasurements else {
//                        self.showErrorMessage(message: "Couldn't load previous nail measurements. Unknown error. Check logs for further investigation.")
//                        return
//                    }
                        
                    //self?.savedMeasurements = nailMeasurements
                }
            } else {
                self?.isSignedIn = false
                KeyChainManager.shared.signOutUser(completion: {
                    success in
                    if success {
                        print("success in logging off")
                    }
                })
            }
        })
    }
    
    func signOutUser() {
        KeyChainManager.shared.signOutUser(completion: {
            [weak self] success in
            if success {
                self?.isSignedIn = false
                self?.userObject = nil
                self?.savedMeasurements = []
            } else {
                print("Could not sign off")
            }
        })
    }
    
    
    func getPostMeasurements() {
        APIServices.shared.getAllPreviousMeasurements() {
            [weak self] errMessage, measurements in
            guard errMessage == nil else {
                print("error for recent measurements")
                return
            }
            
            guard let data = measurements?.measurements  else {
                print("no data")
                return
            }
            
            self?.savedMeasurements = data
        }
    }
    
    func getAllSuccessfulMeasurements() {
        APIServices.shared.getAllUsersSuccessfulMeasurements(completion: {
            [weak self] measurements, success in
            guard success == true else {
                print("got an erorr")
                return
            }
            guard let measurements = measurements else {return}
            self?.successfulMeasurements = measurements.measurements
        })
    }
    
    func getPreviousManualMeasurements(completion: @escaping (SaveNailImagesResponse?) -> Void) {
        APIServices.shared.getPostManualMeasurements(getMeasurements: true, measurements: nil) { [weak self] errorMessage, nailMeasurements in
            
            guard errorMessage == nil else {
                completion(nil)
                return
            }
            
            guard let nailMeasurements = nailMeasurements else {
                completion(nil)
                return
            }
            
            self?.savedManualMeasurements = nailMeasurements
            completion(nailMeasurements)
        }
    }
    
    func getNailSizes() {
        APIServices.shared.getNailSizes(completion: {
            [weak self] sizes, success in
            if success {
                self?.nailSizes = sizes?.NailSizes ?? []
                self?.sizesReturned = true
            } else {
                self?.sizesReturned = false
            }
        })
    }
    
    func getAllAvatars() {
        APIServices.shared.getAllAvatars(completion: {
            [weak self] avatars, success in
            if success {
                self?.allAvatars = avatars?.Avatars_list
            } else {
                print("failure in getting avatars")
            }
        })
    }
    
    func getAllProducts() {
        APIServices.shared.getAllProducts(completion: {
            [weak self] products, success in
            if success {
                if let products = products {
                    print("got all products")
                    self?.allProducts = products.Products_list
                }
            } else {
                print("failure to get products")
            }
            
        })
    }
    
//    func getHandPhotos(completion: @escaping (Bool) -> Void) {
//        APIServices.shared.getHandPhotos(completion: {
//            handList, success in
//            if success {
//                print("success in getting hand photos")
//                self.handPhotosAssetsRecieved = true
//                //SharedImageManager.shared.HandList = handList?.Handphotos_list ?? []
//                SharedImageManager.shared.convertImages(handList: handList?.Handphotos_list ?? [], completion: { success in
//                    if success {
//                        completion(true)
//                    } else {
//                        completion(false)
//                    }
//                })
//            } else {
//                print("failure in getting hand photos")
//                self.handPhotosAssetsRecieved = false
//                completion(false)
//            }
//        })
//    }
    
//    public func didSelectACollection(selected: SavedCustomNailCollection) {
//        let newCollectionsOrder: [SavedCustomNailCollection] = []
//        newCollectionsOrder.append(selected)
//
//        for collection in self.SavedCollections {
//            if collection != selected {
//                newCollectionsOrder.append(collection)
//            }
//        }
//
//        self.NewOrderCollections = newCollectionsOrder
//    }
    
}
