//
//  NailCameraView.swift
//  MeAmoraNails
//
//  Created by Jason bartley on 11/2/24.
//

import Foundation
import SwiftUI
import Vision
import VisionKit

struct NailCameraView: View {
    @EnvironmentObject var environment: EnvironmentViewModel
    
    @ObservedObject var viewModel = NailCameraViewModel()
    
    @State var cameraHeight: CGFloat = 100 {
        didSet {
            print("camera height: \(cameraHeight)")
        }
    }
    
    @State var measureOthers: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.white.ignoresSafeArea(.all)
                
                
                NailCameraRepresentable(alertItem: $viewModel.alertItem, capturedImage: $viewModel.capturedImage, submissionImage: $viewModel.currentSubmissionPhoto, disableCaptureButton: $viewModel.disableCaptureButton,  showFinishImage: $viewModel.showSubmissionImage, isFlashOn: $viewModel.isFlashOn, didSnapPhoto: $viewModel.didSnapPhoto, showLevelCardView: $viewModel.showLevelCardView, isGyroOn: $viewModel.isGyroOn, isCardDetected: $viewModel.isCardDetected, isHandDetected: $viewModel.isHandDetected, isThumbDetected: $viewModel.isThumbDetected, currentHand: $viewModel.currentHandString, autoDetectMessage: $viewModel.autoDetectMessage, MeasureOther: $viewModel.measureOthers, badCameraError: $viewModel.showBadCameraPopUp)
                    .background(
                        GeometryReader {
                            geometry in
                            Color.clear
                                .preference(key: CameraViewPreferenceKey.self, value: geometry.size)
                                .onAppear(perform: {
                                    SharedScreenManager.shared.cameraX = geometry.frame(in: .global).minX
                                    SharedScreenManager.shared.cameraY = geometry.frame(in: .global).minY
                                })
                        }
                    )
                    .onPreferenceChange(CameraViewPreferenceKey.self) {
                        size in
                        SharedScreenManager.shared.cameraViewHeight = size.height
                        SharedScreenManager.shared.cameraViewWidth = size.width
                        SharedScreenManager.shared.cameraX = 0
                    }
                
                VStack {
                    Spacer().frame(width: 200, height: 55)
                    
                    HStack {
                        if !viewModel.isRetakeMode {
                            BackButton().padding().onTapGesture(perform: {
                                didTapBack()
                            })
                        } else {
                            BackButton().hidden()
                        }
                        
                        Spacer()
                        
                        VStack {
                            Text(viewModel.currentNailTitle)
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(.myDarkGray)
                            
                            ZStack {
                                Text(" ").frame(width: 180, height: 7)
                                    .background(Color.myLightGray)
                                    .cornerRadius(5)
                                
                                HStack {
                                    Text(" ").frame(width: viewModel.loadingBarSize, height: 7)
                                        .background(Color.myMeAmore)
                                        .cornerRadius(5)
                                    
                                    Spacer()
                                }
                            }.frame(width: 180, height: 10)
                        }
                        
                        Spacer()
                        
                        XMarkButton().padding().onTapGesture(perform: {
                            viewModel.showOptionMenu = true
                            viewModel.isGyroOn = false
                            viewModel.responsesReturned = 0
                            viewModel.currentNailSelected = .leftHand
                            viewModel.currentHandString = "hand"
                        })
                        
                    }
                    
                    if !viewModel.measureOthers {
                        if SharedScreenManager.shared.height ?? 700 > 650 {
                            Image("DashedLineCamera")
                        }
                        
                        HStack {
                            if viewModel.showLevelCardView {
                                Image("ThickRedCardOutline")
                            } else {
                                Image("ThickWhiteCardOutline")
                            }
                        }.scaleEffect(CGSize(width: SharedScreenManager.shared.height ?? 700 < 650 ? 0.6 : 0.9, height: SharedScreenManager.shared.height ?? 700 < 650 ? 0.6 : 0.9), anchor: .center)
                            .background(
                                GeometryReader {
                                    geometry in
                                    Color.clear
                                        .preference(key: CardViewPreferenceKey.self, value: geometry.size)
                                        .onAppear(perform: {
                                            SharedScreenManager.shared.cardX = geometry.frame(in: .global).minX
                                            SharedScreenManager.shared.cardY = geometry.frame(in: .global).minY
                                        })
                                }
                            )
                            .onPreferenceChange(CardViewPreferenceKey.self) {
                                size in
                                SharedScreenManager.shared.cardHeight = size.height
                                SharedScreenManager.shared.cardWith = size.width
                            }
                        
                        if SharedScreenManager.shared.height ?? 700 > 650 {
                            Image("DashedLineCamera").hidden()
                        }
                        
                        
                        if viewModel.currentNailSelected == .leftHand {
                            Image("LeftHandCaptureImage")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: geo.size.width * 0.7)
                                .offset(y: 5)
                                .scaleEffect(CGSize(width: 1.2, height: 1.2), anchor: .center)
                        }
                        if viewModel.currentNailSelected == .rightHand {
                            Image("RightHandCaptureImage")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: geo.size.width * 0.7)
                                .offset(y: 5)
                                .scaleEffect(CGSize(width: 1.2, height: 1.2), anchor: .center)
                        }
                        if viewModel.currentNailSelected == .leftThumb || viewModel.currentNailSelected == .rightThumb {
                            Image("ThumbCaptureImage")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: geo.size.width/3.25)
                                .offset(y: 10)
                                .scaleEffect(CGSize(width: 1.0, height: 1.0), anchor: .center)
                        }
                    } else {
                        if viewModel.currentNailSelected == .leftHand {
                            Image("LeftHandCaptureImage")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: geo.size.width * 3)
                                .offset(y: -5)
                                .scaleEffect(CGSize(width: 1.2, height: 1.2), anchor: .center)
                                .rotationEffect(.degrees(180))
                        }
                        if viewModel.currentNailSelected == .rightHand {
                            Image("RightHandCaptureImage")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: geo.size.width * 3)
                                .offset(y: -5)
                                .scaleEffect(CGSize(width: 1.2, height: 1.2), anchor: .center)
                                .rotationEffect(.degrees(180))
                        }
                        if viewModel.currentNailSelected == .leftThumb || viewModel.currentNailSelected == .rightThumb {
                            Image("ThumbCaptureImage")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: geo.size.width/3.25)
                                .offset(y: -10)
                                .scaleEffect(CGSize(width: 1.0, height: 1.0), anchor: .center)
                                .rotationEffect(.degrees(180))
                        }
                        
                        if SharedScreenManager.shared.height ?? 700 > 650 {
                            Image("DashedLineCamera").hidden()
                                .offset(y: -5)
                        }
                        
                        HStack {
                            if viewModel.showLevelCardView {
                                Image("ThickRedCardOutline")
                            } else {
                                Image("ThickWhiteCardOutline")
                            }
                        }
                        .offset(y: -5)
                        .scaleEffect(CGSize(width: 0.9, height: 0.9), anchor: .center)
                            .background(
                                GeometryReader {
                                    geometry in
                                    Color.clear
                                        .preference(key: CardViewPreferenceKey.self, value: geometry.size)
                                        .onAppear(perform: {
                                            SharedScreenManager.shared.cardX = geometry.frame(in: .global).minX
                                            SharedScreenManager.shared.cardY = geometry.frame(in: .global).minY
                                        })
                                }
                            )
                            .onPreferenceChange(CardViewPreferenceKey.self) {
                                size in
                                SharedScreenManager.shared.cardHeight = size.height
                                SharedScreenManager.shared.cardWith = size.width
                            }
                        
                        if SharedScreenManager.shared.height ?? 700 > 650 {
                            Image("DashedLineCamera")
                                .offset(y: -5)
                        }
                    }
                    
                    Spacer()
                    
                    ZStack {
                        Color.white
                                .frame(width: geo.size.width, height: 170)
                       
                        VStack {
                            Text(viewModel.autoDetectMessage)
                                .foregroundStyle(.myMeAmore)
                                .font(.system(size: 17, weight: .bold))
                                .offset(y: -10)
                            
                            HStack {
                                VStack {
                                    
                                    InfoButton().onTapGesture {
                                        switch viewModel.currentNailSelected {
                                        case .rightHand:
                                            viewModel.isShowingCameraGuideline = true
                                        case .rightThumb:
                                            viewModel.isShowingCameraGuideline = true
                                        case .leftHand:
                                            viewModel.isShowingCameraGuideline = true
                                        case .leftThumb:
                                            viewModel.isShowingCameraGuideline = true
                                        }
                                    }.disabled(viewModel.disableCaptureButton)
                                        .padding()
                                        .hidden()
                                    
                                    Text("Guide").font(.system(size: 12))
                                        .hidden()
                                    
                                }.padding(.trailing, 15)
                                    .frame(width: 100)
                                
                                VStack {
                                    
                                    CaptureButton(viewModel: self.viewModel).onTapGesture(perform: {
                                        didTapCapture()
                                    }).disabled(viewModel.disableCaptureButton)
                                    
                                    
                                    Text("Capture")
                                        .foregroundStyle(viewModel.disableCaptureButton ?  .myDarkGray : .myMeAmore)
                                        .font(.system(size: 14, weight: .semibold))
                                        .offset(y: 5)
                                    
                                }
                                
                                VStack {
                                    FlashButton(isFlashOn: $viewModel.isFlashOn).onTapGesture {
                                        viewModel.isFlashOn.toggle()
                                    }.disabled(viewModel.disableCaptureButton)
                                        .padding()
                                    
                                    Text("Flash").font(.system(size: 12))
                                }.padding(.leading, 15)
                                    .frame(width: 100)
                            }.offset(y: -10)
                        }
                        
                        Spacer().frame(width: 200, height: 50)
                    }
                }
                
                if viewModel.isShowingLoadingView {
                    loadingView().opacity(0.7)
                }
                
                if viewModel.showSubmissionImage || viewModel.showBadCameraPopUp || viewModel.showUnableToUploadImagesPopUp || viewModel.showErrorPopUp {
                    Color(.myDarkGray).ignoresSafeArea().opacity(0.7).blur(radius: 30.0)
                }
                
                if viewModel.showSubmissionImage {
                    SubmissionPhotoView(submissionPhoto: $viewModel.currentSubmissionPhoto, nailCameraViewModel: self.viewModel)
                        .overlay(RoundedRectangle(cornerRadius: 30).stroke(.myLightGray, lineWidth: 2.0))
                }
                
                if viewModel.showErrorPopUp {
                    ErrorPopUp(nailCameraViewModel: self.viewModel)
                }
                
                if viewModel.showBadCameraPopUp {
                    CameraBadInputDevicesPopUp(viewModel: self.viewModel)
                }
                
                if viewModel.showUnableToUploadImagesPopUp {
                    CameraIssuePopUp(viewModel: self.viewModel)
                }
                
//                if viewModel.isShowingCameraGuideline {
//                    CameraGuidelineScreen(viewModel: self.viewModel)
//                }
//                
                
            }.ignoresSafeArea()
                .onDisappear(perform: {
                    self.viewModel.responsesReturned = 0
                    self.viewModel.errorsReturned = 0
                })
                .navigationBarBackButtonHidden(true)
                .alert(item: $viewModel.alertItem) {
                    item in
                    Alert(title: Text(item.title), message: Text(item.message), dismissButton: item.dismissbutton)
                }
                .onReceive(NotificationCenter.default.publisher(for: Notification.Name("CaptureTriggered")), perform: { _ in
                    self.didTapCapture()
                })
        }
    }
    
    func didTapCapture() {
        if viewModel.isCardDetected {
            switch viewModel.currentNailSelected {
            case .rightHand:
                SharedCoreMLModel.shared.disableModelProcessing = true
                viewModel.didSnapPhoto = true
                viewModel.isShowingLoadingView = true
                viewModel.disableCaptureButton = true
            case .rightThumb:
                SharedCoreMLModel.shared.disableModelProcessing = true
                viewModel.didSnapPhoto = true
                viewModel.isShowingLoadingView = true
                viewModel.disableCaptureButton = true
            case .leftHand:
                SharedCoreMLModel.shared.disableModelProcessing = true
                viewModel.didSnapPhoto = true
                viewModel.isShowingLoadingView = true
                viewModel.disableCaptureButton = true
                
            case .leftThumb:
                SharedCoreMLModel.shared.disableModelProcessing = true
                viewModel.didSnapPhoto = true
                viewModel.isShowingLoadingView = true
                viewModel.disableCaptureButton = true
            }
        } else {
            self.viewModel.showErrorPopUp = true
        }
    }
    
    
    func didTapBack() {
        switch viewModel.currentNailSelected {
        case .rightHand:
            viewModel.responsesReturned -= 1
            viewModel.currentNailSelected = .leftThumb
            viewModel.currentHandString = "thumb"
        case .rightThumb:
            viewModel.responsesReturned -= 1
            viewModel.currentNailSelected = .rightHand
            viewModel.currentHandString = "hand"
        case .leftHand:
            viewModel.responsesReturned -= 1
            viewModel.showOptionMenu = true
        case .leftThumb:
            viewModel.responsesReturned -= 1
            viewModel.currentNailSelected = .leftHand
            viewModel.currentHandString = "hand"
        }
    }
}

struct BackButton: View {
    var body: some View {
        ZStack {
            Circle().frame(width: 30, height: 30)
                .foregroundColor(.myDarkGray)
                .opacity(0.6)
            Image(systemName: "chevron.left").frame(width: 44, height: 44)
                .foregroundColor(.white)
        }
    }
}

struct XMarkButton: View {
    var body: some View {
        ZStack {
            Circle().frame(width: 30, height: 30)
                .foregroundColor(.myDarkGray)
                .opacity(0.6)
            Image(systemName: "xmark").frame(width: 44, height: 44)
                .foregroundColor(.white)
        }
    }
}

struct XMarkButtonSmall: View {
    var body: some View {
        ZStack {
            Circle().frame(width: 25, height: 25)
                .foregroundColor(.myDarkGray)
                .opacity(0.6)
            Image(systemName: "xmark").frame(width: 44, height: 44)
                .foregroundColor(.white)
        }
    }
}

struct CaptureButton: View {
    
    @ObservedObject var viewModel: NailCameraViewModel
    
    var body: some View {
        ZStack {
            Text(" ").frame(width: 160, height: 50).background(Color(viewModel.isShowingLoadingView ? .myDarkGray : .myMeAmore)).foregroundStyle(.white).cornerRadius(30)
            
            Image("CaptureIcon")
        }
    }
}

struct InfoButton: View {
    var body: some View {
        ZStack {
            //            Circle().frame(width: 45, height: 45)
            //                .foregroundColor(.myDarkGray)
            //                .opacity(0.6)
            //            Image(systemName: "info.circle.fill").resizable().frame(width: 30, height: 30)
            //                .foregroundColor(.white)
            Image("InfoIcon")
        }
    }
}

struct FlashButton: View {
    
    @Binding var isFlashOn: Bool
    
    var body: some View {
        ZStack {
            //            Circle().frame(width: 45, height: 45)
            //                .foregroundColor(.myDarkGray)
            //                .opacity(0.6)
            //            Image(systemName: "flashlight.on.fill").resizable().frame(width: 17, height: 30)
            //                .foregroundColor(isFlashOn ? .yellow : .white)
            Image("FlashIcon")
        }
    }
}

struct CardViewPreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

struct CameraViewPreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

struct CameraIssuePopUp: View {
    @ObservedObject var viewModel: NailCameraViewModel
    
    var body: some View {
        ZStack {
            Color.myDarkGray.opacity(0.9).ignoresSafeArea()
            
            Color.white.frame(width: 320, height: 235).cornerRadius(30)
            
            VStack {
                Text("An issue ocurred with uploading images").font(.system(size: 20, weight: .semibold)).padding()
                    .multilineTextAlignment(.center)
                
                Text("Please try again later.").font(.system(size: 18)).padding(.bottom).offset(y: -10)
                
                OrangeButtonView(text: "ok").onTapGesture {
                    self.viewModel.showUnableToUploadImagesPopUp = false
                }
                .padding(.bottom)
            }
        }
    }
}

struct CameraBadInputDevicesPopUp: View {
    @ObservedObject var viewModel: NailCameraViewModel
    
    var body: some View {
        ZStack {
            Color.myDarkGray.opacity(0.9).ignoresSafeArea()
            
            Color.white.frame(width: 320, height: 235).cornerRadius(30)
            
            VStack {
                Text("Invaliud input devices.").font(.system(size: 20, weight: .semibold)).padding()
                    .multilineTextAlignment(.center)
                
                Text("Something is wrong with camera, we are \nunable to capture input")
                    .font(.system(size: 15)).padding(.bottom).offset(y: -10)
                    .multilineTextAlignment(.center)
                
                OrangeButtonView(text: "ok").onTapGesture {
                    self.viewModel.showOptionMenu = true
                }
                .padding(.bottom)
            }
        }
    }
}
