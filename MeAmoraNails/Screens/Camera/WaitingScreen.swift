//
//  WaitingScreen.swift
//  MeAmoraNails
//
//  Created by Jason bartley on 11/2/24.
//

import Foundation
import SwiftUI

struct WaitingScreen: View {
    @EnvironmentObject var environment: EnvironmentViewModel
    
    @StateObject var viewModel = WaitingScreenViewModel()
    
    @ObservedObject var nailViewModel = NailCameraViewModel()
    
    var body: some View {
        ZStack {
            Color(.white).ignoresSafeArea()
            
            VStack {
                
                ZStack {
                    Text(" ").frame(width: 250, height: 7)
                        .background(Color.myLightGray)
                        .cornerRadius(5)
                    
                    HStack {
                        Text(" ").frame(width: viewModel.currentContext.loadingBarSize, height: 7)
                            .background(Color.myMeAmore)
                            .cornerRadius(5)
                        
                        Spacer()
                    }
                }.frame(width: 250, height: 10).padding()
                
                Text("This usually takes less than 30 seconds")
                
                //Text(viewModel.currentContext.message).font(.system(size: 17, weight: .medium)).padding()
                
//                Text(viewModel.currentContext.secondMessage).font(.system(size: 14, weight: .semibold)).frame(width: 270).foregroundStyle(.myDarkGray)
                
//                if viewModel.slowInternetDetected {
//                    Text("Looks like slow internet detected!")
//                        .padding(.top)
//                        .foregroundStyle(.myOrange)
//                    Text("Hang tight results are on the way")
//                        .font(.system(size: 15))
//                        .foregroundStyle(.myOrange)
//                }
                
            }
            
            
                VStack {
                    Text("Measuring your results...").font(.system(size: 24, weight: .bold)).padding()
                    
                    Spacer()
                }
            
        }.multilineTextAlignment(.center)
            .onAppear(perform: {
                viewModel.currentStage = .one
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: {
                    self.updateView()
                })
            })
            .onDisappear(perform: {
                self.viewModel.slowInternetDetected = false
            })
    }
    
    func updateView() {
        nextStage()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            self.updateView()
        })
    }
    
    func nextStage() {
        switch viewModel.currentStage {
        case .one:
            self.viewModel.currentStage = .two
        case .two:
            self.viewModel.currentStage = .three
        case .three:
            self.viewModel.currentStage = .four
        case .four:
            self.viewModel.currentStage = .five
        case .five:
            self.viewModel.currentStage = .five
            self.detectSlowConnection()
        }
    }
    
    func detectSlowConnection() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 7.0, execute: {
            self.viewModel.slowInternetDetected = true
        })
    }
}
