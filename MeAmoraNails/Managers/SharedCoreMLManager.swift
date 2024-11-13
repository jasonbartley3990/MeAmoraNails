//
//  SharedCoreMLManager.swift
//  MeAmoraNails
//
//  Created by Jason bartley on 11/1/24.
//

import Foundation
import CoreML

final class SharedCoreMLModel {

    static let shared = SharedCoreMLModel()
    
//    public var autoDetectModel: autoCaptureModel?
//    
    //public var autoDetectModelFlip: autoCaptureModelFlip?
    
    public var autoDetectModelV3: autoCaptureModelV3?
    
    public var disableModelProcessing: Bool = false
    
    public var readyForProcessing: Bool = false

    private init() {}
    
    public func setUpModels() {
        setUPAutoDetectV3Model()
        //setUpAutoDetectFlipModel()
    }
    
//    public func setUpAutoDetectModel() {
//        do {
//            let config = MLModelConfiguration()
//            let model = try autoCaptureModel(configuration: config)
//            self.autoDetectModel = model
//            self.readyForProcessing = false
//            print("got auto detect model")
//        } catch {
//            print("could not get auto detect model")
//        }
//    }
//    
//    public func setUpAutoDetectFlipModel() {
//        do {
//            let config = MLModelConfiguration()
//            let model = try autoCaptureModelFlip(configuration: config)
//            self.autoDetectModelFlip = model
//            self.readyForProcessing = false
//            print("got auto detect flip model")
//        } catch {
//            print("could not get auto detect flip model")
//        }
//    }
    
    public func setUPAutoDetectV3Model() {
        do {
            let config = MLModelConfiguration()
            let model = try autoCaptureModelV3(configuration: config)
            self.autoDetectModelV3 = model
            self.readyForProcessing = false
            print("got auto detect v3 model")
        } catch {
            print("could not get auto detect flip model")
        }
        
    }
    
    
}
