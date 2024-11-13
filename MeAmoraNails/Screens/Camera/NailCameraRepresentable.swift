//
//  NailCameraRepresentable.swift
//  MeAmoraNails
//
//  Created by Jason bartley on 11/2/24.
//

import Foundation
import SwiftUI
import UIKit

struct NailCameraRepresentable: UIViewControllerRepresentable {
    
    @Binding var alertItem: CameraAlertItem?
    
    @Binding var capturedImage: UIImage?
    
    @Binding var submissionImage: UIImage?
    
    @Binding var disableCaptureButton: Bool
    
    @Binding var showFinishImage: Bool
    
    @Binding var isFlashOn: Bool
    
    @Binding var didSnapPhoto: Bool
    
    @Binding var showLevelCardView: Bool
    
    @Binding var isGyroOn: Bool
    
    @Binding var isCardDetected: Bool
    
    @Binding var isHandDetected: Bool
    
    @Binding var isThumbDetected: Bool
    
    @Binding var currentHand: String
    
    @Binding var autoDetectMessage: String
    
    @Binding var MeasureOther: Bool
    
    @Binding var badCameraError: Bool
    
    func makeCoordinator() -> Coordinator {
        Coordinator(camera: self)
    }
    
    func makeUIViewController(context: Context) -> NailCamera {
        NailCamera(nailCameraDelegate: context.coordinator)
    }
    
    func updateUIViewController(_ uiViewController: NailCamera, context: Context) {
        if isFlashOn {
            uiViewController.turnOnFlash()
        } else {
            uiViewController.turnOffFlash()
        }
        
        if didSnapPhoto {
            self.didSnapPhoto = false
            uiViewController.capturePhoto()
        }
        
        uiViewController.handType = self.currentHand
        
        if isGyroOn {
            DispatchQueue.main.async {
                uiViewController.setGyro()
            }
        } else {
            DispatchQueue.main.async {
                uiViewController.stopGyros()
            }
        }
        
        uiViewController.measureOther = MeasureOther
        
    }
    
    
    final class Coordinator: NSObject, NailCameraDelegate {
        
        
        func showlevelCardView(show: Bool) {
            self.nailCamera.showLevelCardView = show
        }
        
        private let nailCamera: NailCameraRepresentable
        
        init(camera: NailCameraRepresentable) {
            self.nailCamera = camera
        }
        
        func errorDidSurface() {
            DispatchQueue.main.async { [weak self] in
                self?.nailCamera.badCameraError = true
            }
        }
        
        func photoWasCaptured(uiImage: UIImage) {
            nailCamera.capturedImage = uiImage
        }
        
        func disableCapturedButton() {
            nailCamera.disableCaptureButton = true
        }
        
        func showFinishImage(image: UIImage?) {
            guard let image = image else {return}
            nailCamera.submissionImage = image
            nailCamera.showFinishImage = true
        }
        
        func updateAutoCaptureIssue(text: String) {
            self.nailCamera.autoDetectMessage = text
        }
    }
}
