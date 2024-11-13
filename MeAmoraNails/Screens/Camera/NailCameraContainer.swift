//
//  NailCameraContainer.swift
//  MeAmoraNails
//
//  Created by Jason bartley on 11/2/24.
//

import Foundation
import SwiftUI

struct NailCameraContainer: View {
    
    @EnvironmentObject var environment: EnvironmentViewModel
    
    @StateObject var viewModel = NailCameraViewModel()
    
    var body: some View {
        ZStack {
            NailCameraView(viewModel: self.viewModel)
            
//            if viewModel.isShowingHandInformationScreen {
//                HandInformationScreen(viewModel: self.viewModel)
//            }
//
//            if viewModel.isShowingThumbInformationScreen {
//                ThumbInformationScreen(viewModel: self.viewModel)
//            }
            
            if viewModel.showWaitingScreen {
                WaitingScreen(nailViewModel: self.viewModel)
            }
            
            if viewModel.resultsDidComeBack  {
                NailResultsScreen(viewModel: self.viewModel)
            }
            
            if viewModel.showOptionMenu {
                MeasureOptionsScreen(viewModel: self.viewModel)
            }
            
            if viewModel.showProfile {
                ProfileScreen(viewModel: self.viewModel)
            }
            
            if viewModel.showPreviousMeasurements {
                RecentMeasurementsScreen(viewModel: self.viewModel)
            }
            
            if viewModel.showAccountInformationScreen {
                AccountInformationScreen(nailCameraViewModel: self.viewModel)
            }
        }
        .onAppear(perform: {
            self.viewModel.isGyroOn = true
        })
        .onDisappear(perform: {
            self.viewModel.isGyroOn = false
        })
    }
}
