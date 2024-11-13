//
//  NailResultsScreen.swift
//  MeAmoraNails
//
//  Created by Jason bartley on 11/2/24.
//

import Foundation
import SwiftUI

struct NailResultsScreen: View {
    @ObservedObject var viewModel: NailCameraViewModel
    
    @StateObject var resultsViewModel: ResultsViewModel = ResultsViewModel()
    
    @EnvironmentObject var environment: EnvironmentViewModel
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack {
                Spacer().frame(width: 20, height: 20)
                
                HStack(spacing: 130) {
                    VStack {
                        Spacer().frame(width: 50, height: 58)
                        
                        Text("Left")
                            .foregroundStyle(.myMeAmore)
                        .font(.system(size: 20, weight: .semibold))
                    }
                    
                    VStack {
                        Spacer().frame(width: 50, height: 58)
                    
                        Text("Right")
                            .foregroundStyle(.myMeAmore)
                            .font(.system(size: 20, weight: .semibold))
                    }
                }.padding()
                
                NailSizesView(finger: " Thumb ", leftSize: "\(viewModel.currentResponse?.left_thumb_size ?? 0)", rightSize: "\(viewModel.currentResponse?.right_thumb_size ?? 0)", leftWidth: "\(viewModel.currentResponse?.left_thumb_width ?? 0) mm", rightWidth: "\(viewModel.currentResponse?.right_thumb_width ?? 0) mm", leftLength: "\(viewModel.currentResponse?.left_thumb_length ?? 0) mm", rightLength: "\(viewModel.currentResponse?.right_thumb_length ?? 0) mm").padding(.bottom)
                
                NailSizesView(finger: " Index ", leftSize: "\(viewModel.currentResponse?.left_index_size ?? 0)", rightSize: "\(viewModel.currentResponse?.right_index_size ?? 0)", leftWidth: "\(viewModel.currentResponse?.left_index_width ?? 0) mm", rightWidth: "\(viewModel.currentResponse?.right_index_width ?? 0) mm", leftLength: "\(viewModel.currentResponse?.left_index_length ?? 0) mm", rightLength: "\(viewModel.currentResponse?.right_index_length ?? 0) mm").padding(.bottom)
                
                NailSizesView(finger: "Middle", leftSize: "\(viewModel.currentResponse?.left_middle_size ?? 0)", rightSize: "\(viewModel.currentResponse?.right_middle_size ?? 0)", leftWidth: "\(viewModel.currentResponse?.left_middle_width ?? 0) mm", rightWidth: "\(viewModel.currentResponse?.right_middle_width ?? 0) mm",leftLength: "\(viewModel.currentResponse?.left_middle_length ?? 0) mm", rightLength: "\(viewModel.currentResponse?.right_middle_length ?? 0) mm").padding(.bottom)
                
                NailSizesView(finger: "Ring", leftSize: "\(viewModel.currentResponse?.left_ring_size ?? 0)", rightSize: "\(viewModel.currentResponse?.right_ring_size ?? 0)", leftWidth: "\(viewModel.currentResponse?.left_ring_width ?? 0) mm", rightWidth: "\(viewModel.currentResponse?.right_ring_width ?? 0) mm", leftLength: "\(viewModel.currentResponse?.left_ring_length ?? 0) mm", rightLength: "\(viewModel.currentResponse?.right_ring_length ?? 0) mm").padding(.bottom)
                
                NailSizesView(finger: "Pinky", leftSize: "\(viewModel.currentResponse?.left_pinky_size ?? 0)", rightSize: "\(viewModel.currentResponse?.right_pinky_size ?? 0)", leftWidth: "\(viewModel.currentResponse?.left_pinky_width ?? 0) mm", rightWidth: "\(viewModel.currentResponse?.right_pinky_width ?? 0) mm", leftLength: "\(viewModel.currentResponse?.left_pinky_length ?? 0) mm", rightLength: "\(viewModel.currentResponse?.right_pinky_length ?? 0) mm").padding(.bottom)
                
                Spacer()
                
                OrangeButtonView(text: "Start New Measurement").onTapGesture {
                    SharedCoreMLModel.shared.readyForProcessing = false
                    viewModel.resultsDidComeBack = false
                    viewModel.showOptionMenu = true
                    self.viewModel.currentNailSelected = .leftHand
                    self.viewModel.isRetakeMode = false
                    self.viewModel.currentHandString = "hand"
                }
                .padding(.bottom, 10)
                
//                Text("Account info")
//                    .foregroundStyle(.myKiss)
//                    .onTapGesture {
//                        viewModel.showProfile = true
//                        viewModel.currentNailSelected = .leftHand
//                        viewModel.resultsDidComeBack = false
//                        viewModel.showOptionMenu = true
//                    }
                
                Spacer().frame(width: 100, height: 50)
                
            }
            
            if resultsViewModel.didThrowError {
                Color(.myDarkGray).ignoresSafeArea().opacity(0.7).blur(radius: 30.0)
            }
            
            VStack {
                Spacer().frame(width: 200, height: 60)
                
                HStack {
                    Spacer().frame(width: 29, height: 29)
                    
                    Text("Nail Measurements").font(.system(size: 25, weight: .bold)).padding()
                    
                    Image("ProfileButton")
                        .resizable()
                        .frame(width: 29, height: 29)
                        .onTapGesture {
                            viewModel.showProfile = true
                            viewModel.currentNailSelected = .leftHand
                            viewModel.resultsDidComeBack = false
                            viewModel.showOptionMenu = true
                        }
                }
                
                Spacer()
                
                if resultsViewModel.didThrowError {
                    ZStack {
                        Color.white.frame(width: 500, height: self.resultsViewModel.errorViewSize)
                        VStack {
                            Image("AlertIcon")
                            
                            Text("Something went wrong").font(.system(size: 25, weight: .semibold))
                            
                            if self.resultsViewModel.errors.count >= 1 {
                                Text("\(self.resultsViewModel.errors[0].errorHand) error").padding(.top, 5)
                                
                                Text(resultsViewModel.errors[0].errorDescripton).font(.system(size: 18, weight: .light))
                                    .foregroundStyle(.myDarkGray)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 275)
                                    .padding()
                            }
                            
                            if self.resultsViewModel.errors.count >= 2 {
                                Text("\(self.resultsViewModel.errors[1].errorHand) error").padding(.top, 5)
                                
                                Text(resultsViewModel.errors[1].errorDescripton).font(.system(size: 18, weight: .light))
                                    .foregroundStyle(.myDarkGray)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 275)
                                    .padding()
                            }
                            
                            if self.resultsViewModel.errors.count >= 3 {
                                Text("\(self.resultsViewModel.errors[2].errorHand) error").padding(.top, 5)
                                
                                Text(resultsViewModel.errors[2].errorDescripton).font(.system(size: 18, weight: .light))
                                    .foregroundStyle(.myDarkGray)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 275)
                                    .padding()
                            }
                            
                            if self.resultsViewModel.errors.count >= 4 {
                                Text("\(self.resultsViewModel.errors[3].errorHand) error").padding(.top, 5)
                                
                                Text(resultsViewModel.errors[3].errorDescripton).font(.system(size: 18, weight: .light))
                                    .foregroundStyle(.myDarkGray)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 275)
                                    .padding()
                            }
                            
//                            Text("\(self.resultsViewModel.errorHandText) error").padding(.top, 5)
//
//                            Text(resultsViewModel.errorDescription).font(.system(size: 18, weight: .light))
//                                .foregroundStyle(.myDarkGray)
//                                .multilineTextAlignment(.center)
//                                .frame(width: 275)
//                                .padding()
                            
                            
                            OrangeButtonView(text: "Remeasure").onTapGesture {
                                viewModel.resultsDidComeBack = false
                                viewModel.isRetakeMode = true
                                viewModel.retakeMeasurementId = self.viewModel.currentResponse?.measurementsid
                                SharedCoreMLModel.shared.readyForProcessing = true
                                
                                switch self.resultsViewModel.errorHand {
                                case .rightThumb:
                                    viewModel.currentNailSelected = .rightThumb
                                    viewModel.currentHandString = "thumb"
                                case .leftThumb:
                                    viewModel.currentNailSelected = .leftThumb
                                    viewModel.currentHandString = "thumb"
                                case .rightHand:
                                    viewModel.currentNailSelected = .rightHand
                                    viewModel.currentHandString = "hand"
                                case .leftHand:
                                    viewModel.currentNailSelected = .leftHand
                                    viewModel.currentHandString = "hand"
                                }
                            }
                        }
                    }
                }
            }.ignoresSafeArea()
            
        }.onAppear(perform: {
            SharedCoreMLModel.shared.readyForProcessing = false
            CheckForValidSizes()
            environment.getAllSuccessfulMeasurements()
        })
        
    }
    
    func CheckForValidSizes() {
        if viewModel.currentResponse?.left_hand_processing_issue != nil {
            self.resultsViewModel.didThrowError = true
            self.resultsViewModel.leftHandDidThrowError = true
            let LHerr = ErrorHandModel(hand: .leftHand, errorHand: "Left Hand", errorDescripton: viewModel.currentResponse?.left_hand_processing_issue ?? "An error occured")
            self.resultsViewModel.errors.append(LHerr)
            print("left hand error")
        }
        
        if viewModel.currentResponse?.left_thumb_processing_issue != nil {
            self.resultsViewModel.didThrowError = true
            self.resultsViewModel.leftThumbDidThrowError = true
            
            let LTerr = ErrorHandModel(hand: .leftThumb, errorHand: "Left Thumb", errorDescripton: viewModel.currentResponse?.left_thumb_processing_issue ?? "An error occured")
            self.resultsViewModel.errors.append(LTerr)
            print("left thumb error")
        }
        
        if  viewModel.currentResponse?.right_hand_processing_issue != nil {
            self.resultsViewModel.didThrowError = true
            self.resultsViewModel.rightHandDidThrowError = true
            
            let RHerr = ErrorHandModel(hand: .rightHand, errorHand: "Right Hand", errorDescripton: viewModel.currentResponse?.right_hand_processing_issue ?? "An error occured")
            self.resultsViewModel.errors.append(RHerr)
            print("right hand error")
        }
        
        if viewModel.currentResponse?.right_thumb_processing_issue != nil {
            self.resultsViewModel.didThrowError = true
            self.resultsViewModel.rightThumbDidThrowError = true
            
            let RTerr = ErrorHandModel(hand: .rightThumb, errorHand: "Right Thumb", errorDescripton: viewModel.currentResponse?.right_thumb_processing_issue ?? "An error occured")
            self.resultsViewModel.errors.append(RTerr)
            print("right thumb error")
        }
        
        if self.resultsViewModel.leftHandDidThrowError == false {
            if viewModel.currentResponse?.left_index_size == 0 || viewModel.currentResponse?.left_middle_size == 0 || viewModel.currentResponse?.left_ring_size == 0 || viewModel.currentResponse?.left_pinky_size == 0 {
                self.resultsViewModel.didThrowError = true
                let LHerror = ErrorHandModel(hand: .leftHand, errorHand: "Left Hand", errorDescripton: ResultsViewModel.catchAllError)
                self.resultsViewModel.errors.append(LHerror)
            }
        }
        
        if self.resultsViewModel.rightHandDidThrowError == false {
            if viewModel.currentResponse?.right_index_size == 0 || viewModel.currentResponse?.right_middle_size == 0 || viewModel.currentResponse?.right_ring_size == 0 || viewModel.currentResponse?.right_pinky_size == 0 {
                self.resultsViewModel.didThrowError = true
                self.resultsViewModel.rightHandDidThrowError = true
                let RHerror = ErrorHandModel(hand: .rightHand, errorHand: "Right Hand", errorDescripton: ResultsViewModel.catchAllError)
                self.resultsViewModel.errors.append(RHerror)
            }
        }
        
        if self.resultsViewModel.leftThumbDidThrowError == false {
            if self.viewModel.currentResponse?.left_thumb_size == 0 {
                self.resultsViewModel.didThrowError = true
                self.resultsViewModel.leftThumbDidThrowError = true
                let LTerror = ErrorHandModel(hand: .leftThumb, errorHand: "Left Thumb", errorDescripton: ResultsViewModel.catchAllError)
                self.resultsViewModel.errors.append(LTerror)
            }
        }
        
        if self.resultsViewModel.rightThumbDidThrowError == false {
            if self.viewModel.currentResponse?.left_thumb_size == 0 {
                self.resultsViewModel.didThrowError = true
                self.resultsViewModel.rightThumbDidThrowError = true
                let RTerror = ErrorHandModel(hand: .rightThumb, errorHand: "Right Thumb", errorDescripton: ResultsViewModel.catchAllError)
                self.resultsViewModel.errors.append(RTerror)
            }
        }
        
        if resultsViewModel.leftHandDidThrowError {
            self.resultsViewModel.errorHand = .leftHand
        } else {
            if self.resultsViewModel.leftThumbDidThrowError {
                self.resultsViewModel.errorHand = .leftThumb
            } else {
                if self.resultsViewModel.rightHandDidThrowError {
                    self.resultsViewModel.errorHand = .rightHand
                } else {
                    if self.resultsViewModel.rightThumbDidThrowError {
                        self.resultsViewModel.errorHand = .rightThumb
                    }
                }
            }
        }
        
        self.viewModel.errors = self.resultsViewModel.errors
        self.viewModel.totalErrors = self.resultsViewModel.errors.count
    }
    
}

struct NailSizesView: View {
    var finger: String
    
    var leftSize: String
    
    var rightSize: String
    
    var leftWidth: String
    
    var rightWidth: String
    
    var leftLength: String
    
    var rightLength: String
    
    var body: some View {
        HStack {
            VStack {
                HStack {
                    Text("W").foregroundStyle(.myMeAmore)
                        .font(.system(size: 13, weight: .bold))
                        .frame(width: 25)
                    
                    Text(leftWidth).frame(width: 80, height: 28)
                        .foregroundStyle(.myDarkGray)
                        .font(.system(size: 12, weight: .semibold))
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(.myMiddleGrey, lineWidth: 2.0))
                }
                
                HStack {
                    Text("L").foregroundStyle(.myMeAmore)
                        .font(.system(size: 13, weight: .bold))
                        .frame(width: 25)
                    
                    Text(leftLength).frame(width: 80, height: 28)
                        .foregroundStyle(.myDarkGray)
                        .font(.system(size: 12, weight: .semibold))
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(.myMiddleGrey, lineWidth: 2.0))
                }
            }
            
            Text(finger)
                .frame(width: 80)
                .foregroundStyle(.myDarkGray)
            
            VStack {
                HStack {
                    Text(rightWidth).frame(width: 80, height: 28)
                        .foregroundStyle(.myDarkGray)
                        .font(.system(size: 12, weight: .semibold))
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(.myMiddleGrey, lineWidth: 2.0))
                    
                    Text("W").foregroundStyle(.myMeAmore)
                        .frame(width: 25)
                        .font(.system(size: 13, weight: .bold))
                }
                
                HStack {
                    Text(rightLength).frame(width: 80, height: 28)
                        .foregroundStyle(.myDarkGray)
                        .font(.system(size: 12, weight: .semibold))
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(.myMiddleGrey, lineWidth: 2.0))
                    
                    Text("L").foregroundStyle(.myMeAmore)
                        .frame(width: 25)
                        .font(.system(size: 13, weight: .bold))
                }
            }
        }.padding(.bottom, 10)
    }
}
