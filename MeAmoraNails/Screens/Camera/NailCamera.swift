//
//  NailCamera.swift
//  MeAmoraNails
//
//  Created by Jason bartley on 11/2/24.
//

import Foundation
import UIKit
import SwiftUI
import AVFoundation
import CoreMotion
import Vision
import Accelerate

protocol NailCameraDelegate: AnyObject {
    func errorDidSurface()
    func photoWasCaptured(uiImage: UIImage)
    func disableCapturedButton()
    func showFinishImage(image: UIImage?)
    func showlevelCardView(show: Bool)
    func updateAutoCaptureIssue(text: String)
}

final class NailCamera: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var captureSession = AVCaptureSession()
    var stillImageOutput: AVCapturePhotoOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var photoSettings = AVCapturePhotoSettings()
    weak var nailCameraDelegate: NailCameraDelegate!
    var videoDataOutput = AVCaptureVideoDataOutput()
    
    var currentCapturedImage: UIImage?
    var currentImageToSubmit: UIImage?
    
    var backCamera: AVCaptureDevice!
    var backInput: AVCaptureInput!
    
    //Auto detection
    //var autoCapModel: autoCaptureModelFlip?
    var autoCapModel: autoCaptureModelV3?
    var autoDetectCurrentlyProcessing: Bool = false
    var gyroValid: Bool = false
    var autocaptureIssue: String = "Initializing" {
        didSet {
            DispatchQueue.main.async {
                self.nailCameraDelegate.updateAutoCaptureIssue(text: self.autocaptureIssue)
            }
        }
    }
    var autoCaptureIssueC: String = ""
    var autocaptureIssueP: String = ""
    var autoCapReady: Bool = false
    var autoCapDelay: Int = 60
    var handType: String = "hand"
    var autoCapDisabled: Bool = false
    
    // MARK: Gyro Motion
    let motion = CMMotionManager()
    var timer = Timer()
    var GyroVar = 0
    var gyroData: CMGyroData?
    //let allowedGyroError = 0.075
    let allowedGyroError = 0.10
    
    var measureOther: Bool = false
    
    init(previewLayer: AVCaptureVideoPreviewLayer? = nil, nailCameraDelegate: NailCameraDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.previewLayer = previewLayer
        self.nailCameraDelegate = nailCameraDelegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAndStartCaptureSession()
        setUpCardDetectionModel()
        setGyro()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let previewLayer = previewLayer  else {
            return
        }
        previewLayer.frame = view.layer.bounds
    }
    
    private func setUpCaptureSession() {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {return}
        
        let videoInput: AVCaptureDeviceInput
        
        do {
            try videoInput = AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            self.nailCameraDelegate.errorDidSurface()
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            self.nailCameraDelegate.errorDidSurface()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        //previewLayer!.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer!)
        
        captureSession.startRunning()
    }
    
    //MARK: from original camera
    
    func setupAndStartCaptureSession() {
        DispatchQueue.global(qos: .userInitiated).async{
            self.captureSession = AVCaptureSession()
            self.captureSession.beginConfiguration()

            if self.captureSession.canSetSessionPreset(.photo) {
                self.captureSession.sessionPreset = .photo
            }
            
            self.captureSession.automaticallyConfiguresCaptureDeviceForWideColor = true
            
            self.captureSession.commitConfiguration()
            self.captureSession.startRunning()
            
            self.setupPreviewLayer()
            self.setupInputs()
        }
    }
    
    func setupInputs() {
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            backCamera = device
            if self.backCamera.isLowLightBoostSupported == true {
                self.backCamera.automaticallyEnablesLowLightBoostWhenAvailable = true
            }
        } else {
            fatalError("No back camera...Are you running this app on a simulator? If not make sure this device has a build in wide angle camera on back.")
        }
        
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: self.backCamera)
            
            if self.backInput != nil {
                captureSession.removeInput(self.backInput)
            }
            
            self.backInput = captureDeviceInput
            
            captureSession.addInput(captureDeviceInput)
            let output = AVCapturePhotoOutput()
            self.stillImageOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
            
            if self.stillImageOutput != nil {
                captureSession.removeOutput(self.stillImageOutput!)
            }
            
            captureSession.addOutput(output)
            self.stillImageOutput = output
          
            videoDataOutput.videoSettings = [ String(kCVPixelBufferPixelFormatTypeKey) : kCMPixelFormat_32BGRA]
            videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
            captureSession.addOutput(videoDataOutput)
        } catch {
            print(error)
        }
    }
    
    func setupPreviewLayer(){
//        DispatchQueue.main.async {
//            self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
//            self.previewLayer!.videoGravity = .resizeAspectFill
//            self.view.layer.insertSublayer(self.previewLayer, below: self.cameraView.layer)
//            self.previewLayer.frame = self.cameraView.layer.frame
//        }
        
        DispatchQueue.main.async {
            self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
            self.previewLayer!.videoGravity = .resizeAspect
            self.view.layer.addSublayer(self.previewLayer!)
            print("preview layer: \(self.previewLayer?.frame)")
        }
        
    }
    
    func setUpCardDetectionModel() {
            self.autoCapModel = SharedCoreMLModel.shared.autoDetectModelV3
            if self.autoCapModel == nil {
                print("no auto detect model in nailCAM")
                self.autoCapDisabled = true
                self.nailCameraDelegate.updateAutoCaptureIssue(text: "Auto capture not available")
            }
        }
    
//    func setUpCardDetectionModel() {
//        self.autoCapModel = SharedCoreMLModel.shared.autoDetectModelFlip
//        if self.autoCapModel == nil {
//            print("no auto detect model in nailCAM")
//            self.autoCapDisabled = true
//            self.nailCameraDelegate.updateAutoCaptureIssue(text: "Auto capture not available")
//        }
//    }
    
    func capturePhoto() {
        let photoSettings = AVCapturePhotoSettings()
        self.stillImageOutput?.capturePhoto(with: photoSettings, delegate: self)
    }
    
    func turnOnFlash() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        guard device.hasTorch else { return }

        do {
            try device.lockForConfiguration()

            do {
                try device.torchMode = .on
            } catch {
                print(error)
            }
            
            device.unlockForConfiguration()
        } catch {
            print(error)
        }
    }
    
    func turnOffFlash() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        guard device.hasTorch else { return }

        do {
            try device.lockForConfiguration()

            if (device.torchMode == AVCaptureDevice.TorchMode.on) {
                device.torchMode = AVCaptureDevice.TorchMode.off
            }
            device.unlockForConfiguration()
        } catch {
            print(error)
        }
    }
    
    func setGyro() {
        if motion.isDeviceMotionAvailable {
            self.motion.deviceMotionUpdateInterval = 1.0 / 60.0
            self.motion.showsDeviceMovementDisplay = true
            self.motion.startDeviceMotionUpdates(using: .xTrueNorthZVertical)
            
            self.timer = Timer(fire: Date(), interval: (1.0/60.0),
                               repeats: true, block: { (timer) in
                
                // Get the gyro data.
                if let data = self.motion.deviceMotion {
                    let x = data.attitude.pitch
                    let y = data.attitude.yaw
                    let z = data.attitude.roll
                    
                    if x > self.allowedGyroError || x < -self.allowedGyroError || z > self.allowedGyroError || z < -self.allowedGyroError {
                        guard self.nailCameraDelegate != nil else { return}
                        self.nailCameraDelegate.showlevelCardView(show: true)
                        self.gyroValid = false
                    } else {
                        guard self.nailCameraDelegate != nil else {return}
                        self.gyroValid = true
                        self.nailCameraDelegate.showlevelCardView(show: false)
                    }
                }
            })
           
    
            RunLoop.current.add(self.timer, forMode: RunLoop.Mode.default)
        }
    }
    
    
    func stopGyros() {
        if self.timer != nil {
            self.timer.invalidate()
            self.motion.stopGyroUpdates()
        }
    }
}

extension NailCamera: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, willBeginCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings) {}
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        self.nailCameraDelegate.disableCapturedButton()
        
        if let error = error {
            print(error.localizedDescription)
        }
        
        if let image = photo.cgImageRepresentation() {
            //stopGyros()
            let preImage = UIImage(cgImage: image)
            //let capturedImage = UIImage(cgImage: image, scale: preImage.scale, orientation: .right)
            let capturedImage = UIImage(cgImage: image, scale: 1.0, orientation: .right)
            self.currentCapturedImage = capturedImage
            let maskedImage = recognizeText(in: image)
            self.nailCameraDelegate.photoWasCaptured(uiImage: capturedImage)
            
        }
    }
}

extension NailCamera {
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        connection.videoOrientation = .portrait
        
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
           
           if autoCapDisabled == false {
               if SharedCoreMLModel.shared.disableModelProcessing == false && self.autoDetectCurrentlyProcessing == false &&  SharedCoreMLModel.shared.readyForProcessing == true {
                   print("we in detection")
                   // Enable processing flag to block frame processing
                   self.autoDetectCurrentlyProcessing = true
                   
                   // Find issue in current frame
                   
                   if self.gyroValid {
                       guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
                       let imageType = self.handType
                       self.autoCaptureIssueC = self.detectAutoCapture(pixelBuffer: pixelBuffer, imageType: imageType)
                   } else {
                       self.autoCaptureIssueC = "Please level phone"
                   }
                   
                   // Add buffer for issue message update to prevent rapid fluctuations, 2 consecutive matching issues required for update ~ May be best to update to 3
                   // If current and previous are different from old message
                   if self.autoCaptureIssueC == self.autocaptureIssueP && self.autoCaptureIssueC != self.autocaptureIssue {
                       self.autocaptureIssue = self.autoCaptureIssueC
                   }
                   
                   // Update past detections
                   self.autocaptureIssueP = self.autoCaptureIssueC
                   
                   //Start auto capture countdown if first passing frame
                   if self.autocaptureIssue == "Hold Still.." && self.autoCapReady == false {
                       self.autoCapReady = true
                   }
                   
                   // Kill auto capture countdown if no longer passing
                   if self.autocaptureIssue != "Hold Still.." && self.autoCapReady == true {
                       self.autoCapReady = false
                       self.autoCapDelay = 60
                   }
                   
                   // Decrement auto capture countdown ~ Allows for issue to appear non-consecutively on all but final frame
                   if self.autoCapReady == true {
                       // Decrement all non-final frames
                       if self.autoCapDelay > 1 {
                           self.autoCapDelay = self.autoCapDelay - 1
                           // If final frame isnt valid increment cooldown by 2 frames
                       } else if self.autocaptureIssue != "Hold Still.." {
                           self.autoCapDelay = self.autoCapDelay + 2
                           // If final frame is valid trigger auto capture
                       } else {
                           print("AUTO CAPTURE TRIGGERED")
                           NotificationCenter.default.post(name: Notification.Name("CaptureTriggered"), object: nil)
                           self.autoCapReady = false
                           self.autoCapDelay = 60
                           self.autocaptureIssue = "Captured"
                           SharedCoreMLModel.shared.disableModelProcessing = true
                       }
                   }
                   // Disable processing flag to allow next frame to process
                   self.autoDetectCurrentlyProcessing = false
               } else {
                   print("something wrong with boolean")
               }
           }
       }
    
//    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//
//        if autoCapDisabled == false {
//            if SharedCoreMLModel.shared.disableModelProcessing == false && self.autoDetectCurrentlyProcessing == false &&  SharedCoreMLModel.shared.readyForProcessing == true {
//                print("we in in detection")
//                // Enable processing flag to block frame processing
//                self.autoDetectCurrentlyProcessing = true
//
//                // Find issue in current frame
//
//                if self.gyroValid {
//                    guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
//                    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//                    //
//                    // !!!!!!!!!!!!!!!!!! IMAGE TYPE IS CURRENTLY HARD CODED, NEEDS TO BE DYNAMICALLY ADJUSTED BETWEEN "hand" OR "thumb" !!!!!!!!!!!!!!!!!!
//                    // ALSO MAKE SURE THAT autoCapReady is set to false, and autoCapDelay is set to 60 at the start of every capture session
//                    //
//                    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//                    let imageType = self.handType
//                    self.autocaptureIssue = self.detectAutoCapture(pixelBuffer: pixelBuffer, imageType: imageType)
//                } else {
//                    self.autocaptureIssue = "Please level phone"
//                }
//
//                // Add buffer for issue message update to prevent rapid fluctuations, 2 consecutive matching issues required for update ~ May be best to update to 3
//                // If current and previous are different from old message
//                //            if self.autocaptureIssue == self.autocaptureIssueP && self.autocaptureIssue != davidTempSharedViewModel.autocaptureIssue {
//                //                davidTempSharedViewModel.autocaptureIssue = self.autocaptureIssue
//                //}
//
//
//                // Update past detections
//                self.autocaptureIssueP = self.autocaptureIssue
//
//                //Start auto capture countdown if first passing frame
//                if self.autocaptureIssue == "Hold Still.." && self.autoCapReady == false {
//                    self.autoCapReady = true
//                }
//
//                // Kill auto capture countdown if no longer passing
//                if self.autocaptureIssue != "Hold Still.." && self.autoCapReady == true {
//                    self.autoCapReady = false
//                    self.autoCapDelay = 60
//                }
//
//                // Decrement auto capture countdown ~ Allows for issue to appear non-consecutively on all but final frame
//                if self.autoCapReady == true {
//                    // Decrement all non-final frames
//                    if self.autoCapDelay > 1 {
//                        self.autoCapDelay = self.autoCapDelay - 1
//                        // If final frame isnt valid increment cooldown by 2 frames
//                    } else if self.autocaptureIssue != "Hold Still.." {
//                        self.autoCapDelay = self.autoCapDelay + 2
//                        // If final frame is valid trigger auto capture
//                    } else {
//                        // TRIGGER AUTOCAPTURE USING EXISTING 'pixelBuffer' HERE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//                        print("AUTO CAPTURE TRIGGERED")
//                        NotificationCenter.default.post(name: Notification.Name("CaptureTriggered"), object: nil)
//                        self.autoCapReady = false
//                        self.autoCapDelay = 60
//                        self.autocaptureIssue = "Captured"
//                        SharedCoreMLModel.shared.disableModelProcessing = true
//                    }
//                }
//                // Disable processing flag to allow next frame to process
//                self.autoDetectCurrentlyProcessing = false
//            } else {
//                print("something wrong will boolean")
//            }
//        }
//    }
}

extension NailCamera {
    func detectAutoCapture(pixelBuffer: CVPixelBuffer, imageType: String) -> String {
            // Load Model
            guard let model = self.autoCapModel else { return "Model failed to load."}
            // Set Confidence threshold
            let confidenceThresh: Double = 0.7
            // Set NMS IoU threshold
            let nmsThresh: Double = 0.5
            
            // Find size of original pixel buffer
            guard let preImage = UIImage.init(pixelBuffer: pixelBuffer) else {return "Image failed to load."} // Convert the pixel buffer to a UIImage
            let cgImage = preImage.cgImage!
            let uiImage = UIImage(cgImage: cgImage, scale: preImage.scale, orientation: .right) // 'right' orientation rotates buffer 90 deg clockwise, as original buffer seems to be rotated
            let OGcols = Float(uiImage.size.width)
            let OGrows = Float(uiImage.size.height)
            
            // What % of frame dims must card be within ( Top buffer will be halved )
            let CARD_BUFFER = Float(0.1) // Card within 10% of frame border will be rejected
            let CBC = Float(CARD_BUFFER * OGcols)
            let CBR = Float(CARD_BUFFER * OGrows)
            // What % of frame dim must fingers be within
            let FB = Float(0.15) // Finger buffer
            let TB = Float(0.3) // Thumb Buffer
            
            // Rotate the pixel buffer by 90 degrees counterclockwise
            let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
            let rotatedCIImage = ciImage.oriented(.right)
            
            // Resize the image to 128x128
            let context = CIContext()
            let targetSize = CGSize(width: 320, height: 320)
            let scaledCIImage = rotatedCIImage.transformed(by: CGAffineTransform(scaleX: targetSize.width / rotatedCIImage.extent.width, y: targetSize.height / rotatedCIImage.extent.height))
            
            // Create a new CVPixelBuffer
            var newPixelBuffer: CVPixelBuffer?
            let pixelBufferAttributes: [String: Any] = [
                kCVPixelBufferCGImageCompatibilityKey as String: true,
                kCVPixelBufferCGBitmapContextCompatibilityKey as String: true
            ]
            CVPixelBufferCreate(kCFAllocatorDefault, Int(targetSize.width), Int(targetSize.height), CVPixelBufferGetPixelFormatType(pixelBuffer), pixelBufferAttributes as CFDictionary, &newPixelBuffer)
            
            // Render the scaled & rotated image into the new pixel buffer
            if let newPixelBuffer = newPixelBuffer {
                context.render(scaledCIImage, to: newPixelBuffer)

                // Format model input
                let input = autoCaptureModelV3Input(image: newPixelBuffer)
                
                // Run inference
                do {
                    
                    let output = try model.prediction(input: input)

                    // Output is MLMultiArray of shape [1, 6, 2100]
                    let multiArray = output.var_1229
        
                    // Convert MLMultiArray to regular array and do confidence filtering
                    var cardDets = [[Double]]() // Initialize an empty confFilteredArray with arbitrary number of rows and 5 columns
                    var nailDets = [[Double]]() // Initialize an empty confFilteredArray with arbitrary number of rows and 5 columns
                    
                    // Loop over the 2100 elements in the third dimension of multiArray
                    for k in 0..<multiArray.shape[2].intValue { // Loop over 2100
                        // Access the confidence value at index [0, 4, k]
                        let confidenceIndex1 = [0 as NSNumber, 4 as NSNumber, k as NSNumber]
                        let confidence1 = multiArray[confidenceIndex1].doubleValue
                        // Access the confidence value at index [0, 5, k]
                        let confidenceIndex2 = [0 as NSNumber, 5 as NSNumber, k as NSNumber]
                        let confidence2 = multiArray[confidenceIndex2].doubleValue
                        // Check if the confidence meets the threshold
                        if (confidence1 >= confidenceThresh) || (confidence2 >= confidenceThresh){
                            // Initialize a row to store 5 values
                            var row = [Double](repeating: 0.0, count: 5)
                            // Loop over the columns to extract the box
                            for j in 0..<4 {
                                let index = [0 as NSNumber, j as NSNumber, k as NSNumber]
                                row[j] = multiArray[index].doubleValue
                            }
                            // Extract relevant confidence
                            if (confidence1 >= confidenceThresh) {
                                row[4] = multiArray[[0 as NSNumber, 4 as NSNumber, k as NSNumber]].doubleValue
                                nailDets.append(row)
                            }
                            if (confidence2 >= confidenceThresh) {
                                row[4] = multiArray[[0 as NSNumber, 5 as NSNumber, k as NSNumber]].doubleValue
                                cardDets.append(row)
                            }
                        }
                    }
                    
                    //NMS
                    let cardBoxes = cardDets.map { BoundingBox(x: $0[0], y: $0[1], width: $0[2], height: $0[3], score: $0[4]) }
                    let cardSelectedIndices = nonMaximumSuppression(boxes: cardBoxes, threshold: nmsThresh)
                    let cardDetsNMS = cardSelectedIndices.map { cardDets[$0] }
                    let nailBoxes = nailDets.map { BoundingBox(x: $0[0], y: $0[1], width: $0[2], height: $0[3], score: $0[4]) }
                    let nailSelectedIndices = nonMaximumSuppression(boxes: nailBoxes, threshold: nmsThresh)
                    let nailDetsNMS = nailSelectedIndices.map { nailDets[$0] }
                    
                    // DEBUG PRINT RAW DETS AFTER CONF & NMS
                    if false {
                        print("CARD:")
                        for row in cardDetsNMS{
                            print(row)
                        }
                        print("NAIL:")
                        for row in nailDetsNMS{
                            print(row)
                        }
                        print()
                    }
                    
                    // Count number of detections for each class
                    let nailCount = nailDetsNMS.count
                    let cardCount = cardDetsNMS.count
                    
                    // AUTOCAPTURE LOGIC:
                    
                    // Check if number of card detections is as expected
                    if cardCount < 1 {
                        return "No card detected."}
                    if cardCount > 1 {
                        return "More than one card detected."}
                    
                    // Check if number of nail detections is as expected
                    if imageType == "hand" {
                        if nailCount != 4 {
                            return "\(nailCount) nails detected, expected 4."}
                    } else { // Else assumes thumb, can be further checked with additional error for unexpected imageType
                        if nailCount != 1 {
                            return "\(nailCount) nails detected, expected 1."}
                    }
                    
                    // Verify Card Position
                    let (xN, yN, widthN, heightN) = (Float(cardDetsNMS[0][0]/320), Float(cardDetsNMS[0][1]/320), Float(cardDetsNMS[0][2]/320), Float(cardDetsNMS[0][3]/320))
                    let xmin = (xN - (widthN / 2)) * OGcols
                    let ymin = (yN - (heightN / 2)) * OGrows
                    let xmax = (xN + (widthN / 2)) * OGcols
                    let ymax = (yN + (heightN / 2)) * OGrows
                    if (xmin < CBC) && (xmax > (OGcols - CBC)) {
                        return "Please move camera further away."}
                    if (xmin < CBC) || (ymin < (CBR/2)) || (xmax > (OGcols - CBC)) || (ymax > (OGrows - CBR)) {
                        return "Card detected near edge, please center."}
                    
                    // Verify Card Aspect Ratio
                    let widthP = xmax - xmin
                    let heightP = ymax - ymin
                    let aspect_ratio = widthP / heightP
                    if abs(aspect_ratio - 1.586) > 0.15 {
                        return "Detected unusual card shape, please ensure card is standard and straightened."}
                    
                    // Verify Nails are centered
                    let xValues = nailDetsNMS.map { $0[0] }
                    let yValues = nailDetsNMS.map { $0[1] }
                    if let xminP = xValues.min(),
                       let xmaxP = xValues.max(),
                       let yminP = yValues.min(),
                       let ymaxP = yValues.max() {
                        let xminN = Float(xminP) / 320.0
                        let xmaxN = Float(xmaxP) / 320.0
                        let yminN = Float(yminP) / 320.0
                        let ymaxN = Float(ymaxP) / 320.0
                        if (imageType == "hand") && ((xminN < FB) || (yminN < FB) || (xmaxN > (1 - FB)) || (ymaxN > (1 - FB))) {
                            return "Please center fingers."}
                        if (imageType != "hand") && ((xminN < TB) || (yminN < TB) || (xmaxN > (1 - TB)) || (ymaxN > (1 - TB))) {
                            return "Please center thumb."}
                    }
                    
                    // Detect nail overlap ~ONLY NECCASSARY FOR HAND, IF THUMB ONLY 1 NAIL DET IS POSSIBLE AT THIS POINT
                    if imageType == "hand" {
                        // Calculate overlap
                        let hasOverlap = (0..<3).contains { i in
                            (i+1..<4).contains { j in
                                let box1 = nailDetsNMS[i]
                                let box2 = nailDetsNMS[j]
                                let x1 = max(box1[0], box2[0])
                                let y1 = max(box1[1], box2[1])
                                let x2 = min(box1[0] + box1[2], box2[0] + box2[2])
                                let y2 = min(box1[1] + box1[3], box2[1] + box2[3])
                                return x1 < x2 && y1 < y2
                            }
                        }
                        if hasOverlap {
                            return "Space fingers out slightly."}
                    }
                    
                    // Process failed inference
                } catch {
                    print("Autocapture logic failed.")
                }
            } else {
                return "Image resizing failed."
            }
            // If all conditions passed, return string indicating ready to capture, signaling autocapture is ready
            return "Hold Still.."
            
        }
    
//    func detectAutoCapture(pixelBuffer: CVPixelBuffer, imageType: String) -> String {
//            // Load Model
//            guard let model = self.autoCapModel else { return "Model failed to load."}
//
//            // Find size of original pixel buffer
//            guard let preImage = UIImage.init(pixelBuffer: pixelBuffer) else {return "Image failed to load."} // Convert the pixel buffer to a UIImage
//            let cgImage = preImage.cgImage!
//            let uiImage = UIImage(cgImage: cgImage, scale: preImage.scale, orientation: .right) // 'right' orientation rotates buffer 90 deg clockwise, as original buffer seems to be rotated
//            let OGcols = Float(uiImage.size.width)
//            let OGrows = Float(uiImage.size.height)
//
//            // What % of frame dims must card be within ( Top buffer will be halved )
//            let CARD_BUFFER = Float(0.1) // Card within 10% of frame border will be rejected
//            let CBC = Float(CARD_BUFFER * OGcols)
//            let CBR = Float(CARD_BUFFER * OGrows)
//
//            // Rotate the pixel buffer by 90 degrees counterclockwise
//            let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
//            let rotatedCIImage = ciImage.oriented(.right)
//
//            // Resize the image to 128x128
//            let context = CIContext()
//            let targetSize = CGSize(width: 128, height: 128)
//            let scaledCIImage = rotatedCIImage.transformed(by: CGAffineTransform(scaleX: targetSize.width / rotatedCIImage.extent.width, y: targetSize.height / rotatedCIImage.extent.height))
//
//            // Create a new CVPixelBuffer
//            var newPixelBuffer: CVPixelBuffer?
//            let pixelBufferAttributes: [String: Any] = [
//                kCVPixelBufferCGImageCompatibilityKey as String: true,
//                kCVPixelBufferCGBitmapContextCompatibilityKey as String: true
//            ]
//            CVPixelBufferCreate(kCFAllocatorDefault, Int(targetSize.width), Int(targetSize.height), CVPixelBufferGetPixelFormatType(pixelBuffer), pixelBufferAttributes as CFDictionary, &newPixelBuffer)
//
//            // Render the scaled & rotated image into the new pixel buffer
//            if let newPixelBuffer = newPixelBuffer {
//                context.render(scaledCIImage, to: newPixelBuffer)
//
//                // Format model input
//                let input = autoCaptureModelFlipInput(image: newPixelBuffer, iouThreshold: 0.25, confidenceThreshold: 0.6)
//
//                // Run inference
//                do {
//                    let output = try model.prediction(input: input)
//                    // Extract Float32 n * 2 matrix with confidence vals 0-1
//                    // Confidence >0 in col 1 is nail
//                    // Confidence >0 in col 2 is card
//                    let classConfs = output.confidence
//                    // Extract Float32 n*4 matrix with normalized vals (0-1): [ x, y, width, height ]
//                    let boxes = output.coordinates
//
//                    // Convert detection matrices from MLMultiArray to regular 2D array to allow for easier operations
//                    let detectionCount = classConfs.shape[0].intValue
//                    // Class confidences conversion
//                    var classConfs2D: [[Float]] = Array(repeating: Array(repeating: 0.0, count: 2), count: detectionCount) // Always 2 cols
//                    for i in 0..<detectionCount {
//                        for j in 0..<2 {
//                            let index = [i, j] as [NSNumber]
//                            classConfs2D[i][j] = classConfs[index].floatValue
//                        }
//                    }
//                    // Bounding boxes conversion
//                    var boxes2D: [[Float]] = Array(repeating: Array(repeating: 0.0, count: 4), count: detectionCount) // Always 4 cols
//                    for i in 0..<detectionCount {
//                        for j in 0..<4 {
//                            let index = [i, j] as [NSNumber]
//                            boxes2D[i][j] = boxes[index].floatValue
//                        }
//                    }
//
//                    // Count number of detections for each class
//                    let nailCount = classConfs2D.filter { $0[0] > 0 }.count
//                    let cardCount = classConfs2D.filter { $0[1] > 0 }.count
//
//                    // AUTOCAPTURE LOGIC:
//
//                    // Check if number of card detections is as expected
//                    if cardCount < 1 {
//                        return "No card detected."}
//                    if cardCount > 1 {
//                        return "More than one card detected."}
//
//                    // Check if number of nail detections is as expected
//                    if imageType == "hand" {
//                        if nailCount != 4 {
//                            return "\(nailCount) nails detected, expected 4."}
//                    } else { // Else assumes thumb, can be further checked with additional error for unexpected imageType
//                        if nailCount != 1 {
//                            return "\(nailCount) nails detected, expected 1."}
//                    }
//
//                    // Verify Card Position
//                    let cardIndex = classConfs2D.firstIndex { row in row[0] == 0 }!
//                    let (xN, yN, widthN, heightN) = (boxes2D[cardIndex][0], boxes2D[cardIndex][1], boxes2D[cardIndex][2], boxes2D[cardIndex][3])
//                    let xmin = (xN - (widthN / 2)) * OGcols
//                    let ymin = (yN - (heightN / 2)) * OGrows
//                    let xmax = (xN + (widthN / 2)) * OGcols
//                    let ymax = (yN + (heightN / 2)) * OGrows
//                    if (xmin < CBC) || (ymin < (CBR/2)) || (xmax > (OGcols - CBC)) || (ymax > (OGrows - CBR)) {
//                        return "Card detected near edge, please center."}
//                    // Verify Card Aspect Ratio
//                    let widthP = xmax - xmin
//                    let heightP = ymax - ymin
//                    let aspect_ratio = widthP / heightP
//                    if abs(aspect_ratio - 1.586) > 0.15 {
//                        return "Detected unusual card shape, please ensure card is standard and straightened."}
//                    // Verify card size ( Distance between camera and phone
//                    // Remove card detection for futher nail processing
//                    var nailBoxes = boxes2D
//                    nailBoxes.remove(at: cardIndex)
//
//                    // Detect nail overlap ~ONLY NECCASSARY FOR HAND, IF THUMB ONLY 1 NAIL DET IS POSSIBLE AT THIS POINT
//                    if imageType == "hand" {
//                        // Calculate overlap
//                        let hasOverlap = (0..<3).contains { i in
//                            (i+1..<4).contains { j in
//                                let box1 = nailBoxes[i]
//                                let box2 = nailBoxes[j]
//                                let x1 = max(box1[0], box2[0])
//                                let y1 = max(box1[1], box2[1])
//                                let x2 = min(box1[0] + box1[2], box2[0] + box2[2])
//                                let y2 = min(box1[1] + box1[3], box2[1] + box2[3])
//                                return x1 < x2 && y1 < y2
//                            }
//                        }
//                        if hasOverlap {
//                            return "Space fingers out slightly."}
//                    }
//
//                    // Process failed inference
//                } catch {
//                    print("Autocapture logic failed.")
//                }
//            } else {
//                return "Image resizing failed."
//            }
//            // If all conditions passed, return string indicating ready to capture, signaling autocapture is ready
//            return "Hold Still.."
//
//    }
    
    func recognizeText(in image: CGImage) {
        let preImage = UIImage(cgImage: image)
        let uiImage = UIImage(cgImage:image, scale: preImage.scale, orientation: .right)
        let imageRequestHandler = VNImageRequestHandler(cgImage: image, orientation: .right)
        let size = CGSize(width: image.height, height: image.width)
        let bounds = CGRect(origin: .zero, size: size)
        
        // Create a new request to recognize text.
        
        let request = VNRecognizeTextRequest { [self] request, error in
            guard
                let results = request.results as? [VNRecognizedTextObservation],
                error == nil
            else {
                //self.removeSpinner()
                return }
            
            let rects = results.map {
                convert(boundingBox: $0.boundingBox, to: CGRect(origin: .zero, size: size))
            }
            
            let format = UIGraphicsImageRendererFormat()
            format.scale = 1
            let final = UIGraphicsImageRenderer(bounds: bounds, format: format).image { _ in
                uiImage.draw(in: bounds)
                UIColor.white.setStroke()
                
                for rect in rects {
                    //let color = preImage.getPixelColor(pos: CGPoint(x: rect.midX, y: rect.midY))
                    let color = UIColor(Color.mask)
                    color.setFill()
                    let path = UIBezierPath(roundedRect: rect, cornerRadius: CGFloat(rect.height/2.0))
                    path.lineWidth = 1
                    path.stroke()
                    path.fill(with: .normal, alpha: 1.0)
                }
            }
            
            
            DispatchQueue.main.async { [weak self] in
                print("did recognize text")
                //guard let firstImage = self?.imagePreviewView.image else {return}
                guard let firstImage = self?.currentCapturedImage else {return}
                let newImage = self?.imageByCombiningImage(firstImage: firstImage, withImage: final).aspectFittedToHeight(1000) // was a 1000
                self?.currentImageToSubmit = newImage
                if let cg = newImage?.cgImage {
                    self?.detectFace(image: cg, size: size)
                } else {
                    self?.nailCameraDelegate.showFinishImage(image: self?.currentImageToSubmit)
                }
            }
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try imageRequestHandler.perform([request])
                
            } catch {
                print("Failed to perform image request: \(error)")
                return
            }
        }
    }
    
    func convert(boundingBox: CGRect, to bounds: CGRect) -> CGRect {
        let imageWidth = bounds.width
        let imageHeight = bounds.height
        
        // Begin with input rect.
        var rect = boundingBox
        
        // Reposition origin.
        rect.origin.x *= imageWidth
        rect.origin.x += bounds.minX
        rect.origin.y = (1 - rect.maxY) * imageHeight + bounds.minY
        
        // Rescale normalized coordinates.
        rect.size.width *= imageWidth
        rect.size.height *= imageHeight
        
        return rect
    }
    
    private func detectFace(image: CGImage, size: CGSize) {
        let preImage = UIImage(cgImage: image)
        let uiImage = UIImage(cgImage:image, scale: preImage.scale, orientation: .up)
        let bounds = CGRect(origin: .zero, size: size)
        
        let faceDetectionRequest = VNDetectFaceRectanglesRequest() {
            vnRequest, err in
            if let results = vnRequest.results as? [VNFaceObservation], err == nil, results.count > 0 {
                let rects = results.map {
                    self.convert(boundingBox: $0.boundingBox, to: CGRect(origin: .zero, size: size))
                }
                
                let format = UIGraphicsImageRendererFormat()
                format.scale = 1
                let final = UIGraphicsImageRenderer(bounds: bounds, format: format).image { _ in
                    uiImage.draw(in: bounds)
                    UIColor.white.setStroke()
                    
                    for rect in rects {
                        let color = preImage.getPixelColor(pos: CGPoint(x: rect.midX, y: rect.midY))
                        color.setFill()
                        let path = UIBezierPath(roundedRect: rect, cornerRadius: 0)
                        path.lineWidth = 1
                        path.stroke()
                        path.fill(with: .normal, alpha: 1.0)
                    }
                }
                
                DispatchQueue.main.async { [weak self] in
                    guard let firstImage = self?.currentCapturedImage else {return}
                    
                    let newImage = self?.imageByCombiningImage(firstImage: firstImage, withImage: final).aspectFittedToHeight(1000) // was a 1000
                    self?.currentImageToSubmit = newImage
                    self?.nailCameraDelegate.showFinishImage(image: self?.currentImageToSubmit)
                }
                
            } else {
                DispatchQueue.main.async { [weak self] in
                    let img = self?.currentImageToSubmit
                    self?.nailCameraDelegate.showFinishImage(image: self?.currentImageToSubmit)
                }
            }
        }
        
        let imageRequestHandler = VNImageRequestHandler(cgImage: image, orientation: .up)
        
        do {
            try imageRequestHandler.perform([faceDetectionRequest])
        } catch {
            self.nailCameraDelegate.showFinishImage(image: self.currentImageToSubmit)
            print("error with request")
        }
        
    }
    
//    func detectCard(pixelBuffer: CVPixelBuffer) {
//        guard let model = self.cardModel else { return }
//
//        guard let preImage = UIImage.init(pixelBuffer: pixelBuffer) else {return}
//        let cgImage = preImage.cgImage!
//        let uiImage = UIImage(cgImage: cgImage, scale: preImage.scale, orientation: .right)
//        let width = uiImage.size.width ?? 0
//        let height = uiImage.size.height ?? 0
//        let rect = CGRect(x: 60, y: 50, width: (width - 520), height: (height - 100))
//        let croppedImage = cropImage(image: uiImage, toRect: rect)!
////        self.nailCameraDelegate.photoWasCaptured(uiImage: croppedImage)
////        self.nailCameraDelegate.showFinishImage(image: croppedImage)
//        guard let pixBuffer = croppedImage.getCVPixelBuffer() else {return}
//
//        let sourcePixelFormat = CVPixelBufferGetPixelFormatType(pixBuffer)
//        assert(sourcePixelFormat == kCVPixelFormatType_32ARGB ||
//               sourcePixelFormat == kCVPixelFormatType_32BGRA ||
//               sourcePixelFormat == kCVPixelFormatType_32RGBA)
//        let imageChannels = 4
//        assert(imageChannels >= inputChannels)
//        let scaledSize = CGSize(width: inputWidth, height: inputHeight)
//        guard let finalPixelBuffer = pixelBuffer.centerThumbnail(ofSize: scaledSize) else {
//            return
//        }
//
//        //let input = best_3Input(image: finalPixelBuffer)
//        let input = best_3Input(image: finalPixelBuffer, iouThreshold: 0.7, confidenceThreshold: 0.2)
//
//
//        do {
//            let output = try model.prediction(input: input)
//            let prediction = output.confidence
//
//            guard prediction.count > 0 else {
//                print("EMPTY")
//                self.nailCameraDelegate.cardDetected(detected: false)
//                return
//            }
//
//            if Double(prediction[0]) > 0.8 {
//                print("card is there")
//                self.nailCameraDelegate.cardDetected(detected: true)
//            } else {
//                print("card is not there")
//                self.nailCameraDelegate.cardDetected(detected: false)
//            }
//        } catch {
//            print("error with card detection")
//        }
//    }
    
//    func detectHand(pixelBuffer: CVPixelBuffer) {
//        guard let model = self.handModel else { return }
//
//        guard let preImage = UIImage.init(pixelBuffer: pixelBuffer) else {return}
//        let cgImage = preImage.cgImage!
//        let uiImage = UIImage(cgImage: cgImage, scale: preImage.scale, orientation: .right)
//        let width = uiImage.size.width ?? 0
//        let height = uiImage.size.height ?? 0
//        let rect = CGRect(x: 500, y: 50, width: (width - 100), height: (height - 100))
//        let croppedImage = cropImage(image: uiImage, toRect: rect)!
////        self.nailCameraDelegate.photoWasCaptured(uiImage: croppedImage)
////        self.nailCameraDelegate.showFinishImage(image: croppedImage)
//        guard let pixBuffer = croppedImage.getCVPixelBuffer() else {return}
//
//        let sourcePixelFormat = CVPixelBufferGetPixelFormatType(pixBuffer)
//        assert(sourcePixelFormat == kCVPixelFormatType_32ARGB ||
//               sourcePixelFormat == kCVPixelFormatType_32BGRA ||
//               sourcePixelFormat == kCVPixelFormatType_32RGBA)
//        let imageChannels = 4
//        assert(imageChannels >= inputChannels)
//        let scaledSize = CGSize(width: handInputWidth, height: handInputHeight)
//        guard let finalPixelBuffer = pixBuffer.centerThumbnail(ofSize: scaledSize) else {
//            return
//        }
//
//        //let input = best_3Input(image: finalPixelBuffer)
//        let input = best_5Input(image: finalPixelBuffer, iouThreshold: 0.7, confidenceThreshold: 0.2)
//
//
//        do {
//            let output = try model.prediction(input: input)
//            let prediction = output.confidence
//
//            guard prediction.count > 0 else {
//                print("EMPTY (hand)")
//                self.nailCameraDelegate.cardDetected(detected: false)
//                return
//            }
//
//            if Double(prediction[0]) > 0.8 {
//                print("hand is there")
//                self.nailCameraDelegate.cardDetected(detected: true)
//            } else {
//                print("hand is not there")
//                self.nailCameraDelegate.cardDetected(detected: false)
//            }
//        } catch {
//            print("error with hand detection")
//        }
//    }
//
//    func detectThumb(pixelBuffer: CVPixelBuffer) {
//        guard let model = self.thumbModel else { return }
//
//        guard let preImage = UIImage.init(pixelBuffer: pixelBuffer) else {return}
//        let cgImage = preImage.cgImage!
//        let uiImage = UIImage(cgImage: cgImage, scale: preImage.scale, orientation: .right)
//        let width = uiImage.size.width ?? 0
//        let height = uiImage.size.height ?? 0
//        let rect = CGRect(x: 500, y: 50, width: (width - 100), height: (height - 100))
//        let croppedImage = cropImage(image: uiImage, toRect: rect)!
////        self.nailCameraDelegate.photoWasCaptured(uiImage: croppedImage)
////        self.nailCameraDelegate.showFinishImage(image: croppedImage)
//        guard let pixBuffer = croppedImage.getCVPixelBuffer() else {return}
//
//        let sourcePixelFormat = CVPixelBufferGetPixelFormatType(pixBuffer)
//        assert(sourcePixelFormat == kCVPixelFormatType_32ARGB ||
//               sourcePixelFormat == kCVPixelFormatType_32BGRA ||
//               sourcePixelFormat == kCVPixelFormatType_32RGBA)
//        let imageChannels = 4
//        assert(imageChannels >= inputChannels)
//        let scaledSize = CGSize(width: inputWidth, height: inputHeight)
//        guard let finalPixelBuffer = pixBuffer.centerThumbnail(ofSize: scaledSize) else {
//            return
//        }
//
//        let input = best_4Input(image: finalPixelBuffer, iouThreshold: 0.7, confidenceThreshold: 0.2)
//
//
//        do {
//            let output = try model.prediction(input: input)
//            let prediction = output.confidence
//
//            guard prediction.count > 0 else {
//                print("EMPTY (thumb)")
//                self.nailCameraDelegate.cardDetected(detected: false)
//                return
//            }
//
//            if Double(prediction[0]) > 0.8 {
//                print("thumb is there")
//                self.nailCameraDelegate.cardDetected(detected: true)
//            } else {
//                print("thumb is not there")
//                self.nailCameraDelegate.cardDetected(detected: false)
//            }
//        } catch {
//            print("error with thumb detection")
//        }
//    }
    
    func blend(firstImage: UIImage, secondImage: UIImage) -> UIImage {
        let bottomImage = firstImage
        let topImage = secondImage

        let size = CGSize(width: firstImage.size.width, height: firstImage.size.height)
        UIGraphicsBeginImageContext(size)

        let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        bottomImage.draw(in: areaSize)

        topImage.draw(in: areaSize, blendMode: .normal, alpha: 0.8)

        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
        
    }
    
    func imageByCombiningImage(firstImage: UIImage, withImage secondImage: UIImage) -> UIImage {
            
        let newImageWidth  = max(firstImage.size.width,  secondImage.size.width )
        let newImageHeight = max(firstImage.size.height, secondImage.size.height)
        let newImageSize = CGSize(width : newImageWidth, height: newImageHeight)
            
        UIGraphicsBeginImageContextWithOptions(newImageSize, false, UIScreen.main.scale)
            
        let firstImageDrawX  = round((newImageSize.width  - firstImage.size.width  ) / 2)
        let firstImageDrawY  = round((newImageSize.height - firstImage.size.height ) / 2)
            
        let secondImageDrawX = round((newImageSize.width  - secondImage.size.width ) / 2)
        let secondImageDrawY = round((newImageSize.height - secondImage.size.height) / 2)
            
        firstImage .draw(at: CGPoint(x: firstImageDrawX,  y: firstImageDrawY))
        secondImage.draw(at: CGPoint(x: secondImageDrawX, y: secondImageDrawY))
            
        let image = UIGraphicsGetImageFromCurrentImageContext()
            
        UIGraphicsEndImageContext()
            
        return image!
    }
    
    func blurImage(usingImage image: UIImage, blurAmount: (CGFloat)) -> UIImage? {
        guard let ciImage = CIImage(image: image) else { return nil}
        let blurFilter = CIFilter (name: "CIGaussianBlur")
        blurFilter?.setValue(ciImage, forKey: kCIInputImageKey)
        blurFilter?.setValue(blurAmount, forKey: kCIInputRadiusKey)
        guard let outputImage = blurFilter?.outputImage else { return nil }
        return UIImage (ciImage: outputImage)
    }
    
    func cropImage(image: UIImage, toRect: CGRect) -> UIImage? {
        // Cropping is available trhough CGGraphics
        let cgImage :CGImage! = image.cgImage
        let croppedCGImage: CGImage! = cgImage.cropping(to: toRect)

        return UIImage(cgImage: croppedCGImage)
    }
    
}

extension NailCamera {
    func rgbDataFromBuffer(
        _ buffer: CVPixelBuffer,
        byteCount: Int,
        isModelQuantized: Bool
    ) -> Data? {
        CVPixelBufferLockBaseAddress(buffer, .readOnly)
        defer {
            CVPixelBufferUnlockBaseAddress(buffer, .readOnly)
        }
        guard let sourceData = CVPixelBufferGetBaseAddress(buffer) else {
            return nil
        }

        let width = CVPixelBufferGetWidth(buffer)
        let height = CVPixelBufferGetHeight(buffer)
        let sourceBytesPerRow = CVPixelBufferGetBytesPerRow(buffer)
        let destinationChannelCount = 3
        let destinationBytesPerRow = destinationChannelCount * width

        var sourceBuffer = vImage_Buffer(data: sourceData,
                                         height: vImagePixelCount(height),
                                         width: vImagePixelCount(width),
                                         rowBytes: sourceBytesPerRow)

        guard let destinationData = malloc(height * destinationBytesPerRow) else {
            print("Error: out of memory")
            return nil
        }

        defer {
            free(destinationData)
        }

        var destinationBuffer = vImage_Buffer(data: destinationData,
                                              height: vImagePixelCount(height),
                                              width: vImagePixelCount(width),
                                              rowBytes: destinationBytesPerRow)

        let pixelBufferFormat = CVPixelBufferGetPixelFormatType(buffer)

        switch (pixelBufferFormat) {
        case kCVPixelFormatType_32BGRA:
            vImageConvert_BGRA8888toRGB888(&sourceBuffer, &destinationBuffer, UInt32(kvImageNoFlags))
        case kCVPixelFormatType_32ARGB:
            vImageConvert_ARGB8888toRGB888(&sourceBuffer, &destinationBuffer, UInt32(kvImageNoFlags))
        case kCVPixelFormatType_32RGBA:
            vImageConvert_RGBA8888toRGB888(&sourceBuffer, &destinationBuffer, UInt32(kvImageNoFlags))
        default:
            // Unknown pixel format.
            return nil
        }

        let byteData = Data(bytes: destinationBuffer.data, count: destinationBuffer.rowBytes * height)
        if isModelQuantized {
            return byteData
        }

        // Not quantized, convert to floats
        let bytes = Array<UInt8>(unsafeData: byteData)!
        var floats = [Float]()
        for i in 0..<bytes.count {
            floats.append(Float(bytes[i]) / 255.0)
        }
        return Data(copyingBufferOf: floats)
    }
    
}

// MARK: EXTERNAL ML HELPER FUNCTIONS

// Non-Maximum Supression (NMS) Implementation:

// NMS Bounding Box Structure (x, y, w, h, conf)
struct BoundingBox {
    var x: Double
    var y: Double
    var width: Double
    var height: Double
    var score: Double
}

// NMS Helper function to calculate the area of a bounding box
extension BoundingBox {
    func area() -> Double {
        return width * height
    }
}

// NMS Helper function to calculate IoU for two boxes
func iou(box1: BoundingBox, box2: BoundingBox) -> Double {
    let intersectX = max(0, min(box1.x + box1.width, box2.x + box2.width) - max(box1.x, box2.x))
    let intersectY = max(0, min(box1.y + box1.height, box2.y + box2.height) - max(box1.y, box2.y))
    let intersectArea = intersectX * intersectY
    return intersectArea / (box1.area() + box2.area() - intersectArea)
}

// Primary NMS Helper function to apply non-maximum supression to bounding box detections
func nonMaximumSuppression(boxes: [BoundingBox], threshold: Double) -> [Int] {
    let sortedIndices = boxes.enumerated().sorted { $0.element.score > $1.element.score }.map { $0.offset }
    var selectedIndices = [Int]()

    for index in sortedIndices {
        let currentBox = boxes[index]
        var shouldSelect = true
        for selectedIndex in selectedIndices {
            let selectedBox = boxes[selectedIndex]
            if iou(box1: currentBox, box2: selectedBox) > threshold {
                shouldSelect = false
                break
            }
        }
        if shouldSelect {
            selectedIndices.append(index)
        }
    }
    return selectedIndices
}
