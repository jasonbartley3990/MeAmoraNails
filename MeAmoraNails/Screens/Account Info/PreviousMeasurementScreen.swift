//
//  PreviousMeasurementScreen.swift
//  MeAmoraNails
//
//  Created by Jason bartley on 11/2/24.
//

import Foundation
import SwiftUI

struct PreviousMeasurementsScreen: View {
    //var measurement: Measurements
    var measurement: SuccessfulMeasurementsResponseItem
    
    @ObservedObject var viewModel: NailCameraViewModel
    
    @EnvironmentObject var environment: EnvironmentViewModel
    
    @StateObject var resultsViewModel: previousResultViewModel = previousResultViewModel()
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack {
                HStack(spacing: 130) {
                    VStack {
                        Spacer().frame(width: 50, height: 70)
                        
                        Text("Left")
                            .foregroundStyle(.myMeAmore)
                            .font(.system(size: 20, weight: .semibold))
                    }
                    
                    VStack {
                        Spacer().frame(width: 50, height: 70)
                        
                        Text("Right")
                            .foregroundStyle(.myMeAmore)
                            .font(.system(size: 20, weight: .semibold))
                    }
                }.padding()
                
                NailSizesView(finger: " Thumb ", leftSize: "\(measurement.left_thumb_size ?? 0)", rightSize: "\(measurement.right_thumb_size ?? 0)", leftWidth: "\(measurement.left_thumb_width ?? 0) mm", rightWidth: "\(measurement.right_thumb_width ?? 0) mm", leftLength: "\(measurement.left_thumb_length ?? 0) mm", rightLength: "\(measurement.right_thumb_length ?? 0) mm").padding(.bottom)
                
                NailSizesView(finger: " Index ", leftSize: "\(measurement.left_index_size ?? 0)", rightSize: "\(measurement.right_index_size ?? 0)", leftWidth: "\(measurement.left_index_width ?? 0) mm", rightWidth: "\(measurement.right_index_width ?? 0) mm", leftLength: "\(measurement.left_index_length ?? 0) mm", rightLength: "\(measurement.right_index_length ?? 0) mm").padding(.bottom)
                
                NailSizesView(finger: "Middle", leftSize: "\(measurement.left_middle_size ?? 0)", rightSize: "\(measurement.right_middle_size ?? 0)", leftWidth: "\(measurement.left_middle_width ?? 0) mm", rightWidth: "\(measurement.right_middle_width ?? 0) mm",leftLength: "\(measurement.left_middle_length ?? 0) mm", rightLength: "\(measurement.right_middle_length ?? 0) mm").padding(.bottom)
                
                NailSizesView(finger: "Ring", leftSize: "\(measurement.left_ring_size ?? 0)", rightSize: "\(measurement.right_ring_size ?? 0)", leftWidth: "\(measurement.left_ring_width ?? 0) mm", rightWidth: "\(measurement.right_ring_width ?? 0) mm", leftLength: "\(measurement.left_ring_length ?? 0) mm", rightLength: "\(measurement.right_ring_length ?? 0) mm").padding(.bottom)
                
                NailSizesView(finger: "Pinky", leftSize: "\(measurement.left_pinky_size ?? 0)", rightSize: "\(measurement.right_pinky_size ?? 0)", leftWidth: "\(measurement.left_pinky_width ?? 0) mm", rightWidth: "\(measurement.right_pinky_width ?? 0) mm", leftLength: "\(measurement.left_pinky_length ?? 0) mm", rightLength: "\(measurement.right_pinky_length ?? 0) mm").padding(.bottom)
                
                Spacer()
                
                OutlinedOrangeButton(text: "Delete Measurement")
                    .onTapGesture {
                        resultsViewModel.showDeleteMeasurementPopUp = true
                    }
                    .padding(.bottom, 20)
                    .scaleEffect(x: 0.8, y: 0.8)
                
                
                Spacer().frame(width: 100, height: 50)
                
            }
            
            if resultsViewModel.didThrowError {
                Color(.myDarkGray).ignoresSafeArea().opacity(0.7).blur(radius: 30.0)
            }
            
            if resultsViewModel.showDeleteMeasurementPopUp {
                Color(.myDarkGray).ignoresSafeArea().opacity(0.7).blur(radius: 30.0)
            }
            
            if resultsViewModel.showDeleteMeasurementPopUp {
                Color.white.frame(width: 350, height: 350).cornerRadius(30)
                
                VStack {
                    Text("Are you sure you want to delete\nyour measurement?").font(.system(size: 19, weight: .bold))
                        .padding(.bottom, 3)
                        .multilineTextAlignment(.center)
                    
                    
                    OrangeButtonView(text: "        Yes        ").onTapGesture {
                       deleteMeasurements()
                    }.padding(.bottom)
                    
                    OutlinedOrangeButton(text: "         No         ").onTapGesture {
                        self.resultsViewModel.showDeleteMeasurementPopUp = false
                    }
                }
                
            }
            
            VStack {
                Spacer().frame(maxWidth: .infinity, maxHeight: 50)
                HStack {
                    Spacer().frame(width: 20, height: 20)
                    
                    Image("chevron.left").resizable()
                        .frame(width: 10, height: 14).onTapGesture {
                        self.didTapBack()
                        }.offset(x: 2, y: 1)
                    
                    Spacer()
                    
                    Text("My Measurement")
                        .font(.system(size: 25, weight: .bold))
                        .padding()
                    
                    Spacer()
                    
                    Spacer().frame(width: 10, height: 14)
                    
                    Spacer().frame(width: 20, height: 20)
                }
                Spacer()
                if self.resultsViewModel.didThrowError {
                    ZStack {
                        Color.white.frame(width: 500, height: 330)
                        VStack {
                            Image("AlertWarningIcon")
                            
                            Text("Something went wrong").font(.system(size: 25, weight: .semibold))
                            
                            Text("\(self.resultsViewModel.errorHandText) error")
                            
                            Text(self.resultsViewModel.errorDescription).font(.system(size: 18, weight: .light))
                                .foregroundStyle(.myDarkGray)
                                .multilineTextAlignment(.center)
                                .frame(width: 275)
                                .padding()
                            
                            OrangeButtonView(text: "ok").onTapGesture {
                                self.dismiss()
                            }
                        }
                    }
                }
            }.ignoresSafeArea()
            
        }.onAppear(perform: {
            CheckForValidSizes()
            environment.getAllSuccessfulMeasurements()
        })
        .navigationBarBackButtonHidden(true)
    }
    
    func didTapBack() {
        self.dismiss()
    }
    
    func deleteMeasurements() {
        APIServices.shared.deleteMeasurement(id: measurement.measurementsid ?? 0, completion: {
            message, success in
            if success {
                print(success)
                print(message?.message)
                self.environment.savedMeasurements.removeAll(where: {$0.id == self.measurement.id})
                self.dismiss()
            }
        })
    }
    
    func CheckForValidSizes() {
//        guard self.measurement.left_hand_processing_issue == nil else {
//            self.resultsViewModel.didThrowError = true
//            self.resultsViewModel.errorHand = .leftHand
//            self.resultsViewModel.errorDescription = self.measurement.left_hand_processing_issue ?? "An error occured."
//            return
//        }
//        
//        guard self.measurement.right_hand_processing_issue == nil else {
//            self.resultsViewModel.didThrowError = true
//            self.resultsViewModel.errorHand = .rightHand
//            self.resultsViewModel.errorDescription = self.measurement.right_hand_processing_issue ?? "An error occured."
//            return
//        }
//        
//        guard self.measurement.left_thumb_processing_issue == nil else {
//            self.resultsViewModel.didThrowError = true
//            self.resultsViewModel.errorHand = .leftThumb
//            self.resultsViewModel.errorDescription = self.measurement.left_thumb_processing_issue ?? "An error occured"
//            return
//        }
//        
//        guard self.measurement.right_thumb_processing_issue == nil else {
//            self.resultsViewModel.didThrowError = true
//            self.resultsViewModel.errorHand = .rightThumb
//            self.resultsViewModel.errorDescription = self.measurement.right_thumb_processing_issue ?? "An error occured"
//            return
//        }
        
        guard self.measurement.left_thumb_size != 0 else {
            self.resultsViewModel.didThrowError = true
            self.resultsViewModel.errorHand = .leftThumb
            self.resultsViewModel.errorDescription = ResultsViewModel.catchAllError
            return
        }
        
        guard self.measurement.right_thumb_size != 0 else {
            self.resultsViewModel.didThrowError = true
            self.resultsViewModel.errorHand = .rightThumb
            self.resultsViewModel.errorDescription = ResultsViewModel.catchAllError
            return
        }
        
        guard self.measurement.left_index_size != 0 else {
            self.resultsViewModel.didThrowError = true
            self.resultsViewModel.errorHand = .leftHand
            self.resultsViewModel.errorDescription = ResultsViewModel.catchAllError
            return
        }
        
        guard self.measurement.right_index_size != 0 else {
            self.resultsViewModel.didThrowError = true
            self.resultsViewModel.errorHand = .rightHand
            self.resultsViewModel.errorDescription = ResultsViewModel.catchAllError
            return
        }
        
        
        guard self.measurement.left_middle_size != 0 else {
            self.resultsViewModel.didThrowError = true
            self.resultsViewModel.errorHand = .leftHand
            self.resultsViewModel.errorDescription = ResultsViewModel.catchAllError
            return
        }
        
        guard self.measurement.right_middle_size != 0 else {
            self.resultsViewModel.didThrowError = true
            self.resultsViewModel.errorHand = .rightHand
            self.resultsViewModel.errorDescription = ResultsViewModel.catchAllError
            return
        }
        
        guard self.measurement.left_ring_size != 0 else {
            self.resultsViewModel.didThrowError = true
            self.resultsViewModel.errorHand = .leftHand
            self.resultsViewModel.errorDescription = ResultsViewModel.catchAllError
            return
        }
        
        guard self.measurement.right_ring_size != 0 else {
            self.resultsViewModel.didThrowError = true
            self.resultsViewModel.errorHand = .rightHand
            self.resultsViewModel.errorDescription = ResultsViewModel.catchAllError
            return
        }
        
        guard self.measurement.left_pinky_size != 0 else {
            self.resultsViewModel.didThrowError = true
            self.resultsViewModel.errorHand = .leftHand
            self.resultsViewModel.errorDescription = ResultsViewModel.catchAllError
            return
        }
        
        guard self.measurement.right_pinky_size != 0 else {
            self.resultsViewModel.didThrowError = true
            self.resultsViewModel.errorHand = .rightHand
            self.resultsViewModel.errorDescription = ResultsViewModel.catchAllError
            return
        }
    }
}

