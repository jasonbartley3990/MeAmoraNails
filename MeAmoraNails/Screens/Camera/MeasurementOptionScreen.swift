//
//  MeasurementOptionScreen.swift
//  MeAmoraNails
//
//  Created by Jason bartley on 11/2/24.
//

import Foundation
import SwiftUI

struct MeasureOptionsScreen: View {
    @EnvironmentObject var environment: EnvironmentViewModel
    
    @ObservedObject var viewModel: NailCameraViewModel
    
    var body: some View {
        GeometryReader { geo in
            NavigationView {
                ZStack {
                    Color.white.ignoresSafeArea(.all)
                    
                    VStack {
                        Spacer().frame(width: 200, height: 35)
                        
                        HStack {
                            Spacer().frame(width: 29, height: 29)
                            
                            Spacer()
                            
                            Text("Measure Nails").font(.system(size: 25, weight: .bold))
                            
                            Spacer()
                            
                            Image("ProfileButton")
                                .resizable()
                                .frame(width: 29, height: 29)
                                .onTapGesture {
                                    viewModel.showProfile = true
                                    viewModel.currentNailSelected = .leftHand
                                    viewModel.resultsDidComeBack = false
                                    viewModel.showOptionMenu = true
                                }
                        }.frame(width: geo.size.width - 35)
                        
                        Spacer()
                    }
                    
                    VStack {
                        Image("MeasureOthers").onTapGesture {
                            self.viewModel.measureOthers = true
                            self.viewModel.showOptionMenu = false
                            viewModel.selfCapture = "FALSE"
                            viewModel.isRetakeMode = false
                            viewModel.responsesReturned = 0
                            SharedCoreMLModel.shared.readyForProcessing = true
                            wasTapped()
                            
                        }
                        
                        Image("MeasureYourselfButton").onTapGesture {
                            self.viewModel.measureOthers = false
                            self.viewModel.showOptionMenu = false
                            viewModel.selfCapture = "TRUE"
                            viewModel.isRetakeMode = false
                            viewModel.responsesReturned = 0
                            SharedCoreMLModel.shared.readyForProcessing = true
                            wasTapped()
                        }
                    }
                }
            }
        }
    }
    
    func wasTapped() {
        print("tapped")
    }
}
