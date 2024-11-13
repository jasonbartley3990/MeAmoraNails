//
//  SubmissionPhotoView.swift
//  MeAmoraNails
//
//  Created by Jason bartley on 11/2/24.
//

import Foundation
import SwiftUI

struct SubmissionPhotoView: View {
    
    @Binding var submissionPhoto: UIImage?
    
    @ObservedObject var nailCameraViewModel: NailCameraViewModel
    
    var body: some View {
        ZStack {
            
            Color.white.frame(width: 350, height: 620).cornerRadius(30)
            
            VStack {
                if let image = submissionPhoto {
                    if let proportion = nailCameraViewModel.proportion {
                        Image(uiImage: image).resizable().frame(width: 270, height: 270 * proportion).scaledToFit().padding()
                    } else {
                        Image(uiImage: image).resizable().frame(width: 270, height: 270).scaledToFit().padding()
                    }
                }
                
                OrangeButtonView(text: nailCameraViewModel.nextUpText).onTapGesture {
                    nailCameraViewModel.didTapNext()
                    nailCameraViewModel.showSubmissionImage = false
                    nailCameraViewModel.isShowingLoadingView = false
                    nailCameraViewModel.disableCaptureButton = false
                    SharedCoreMLModel.shared.disableModelProcessing = false
                }.padding(.bottom)
                
                Text("Retake").foregroundStyle(.myDarkGray).onTapGesture {
                    nailCameraViewModel.showSubmissionImage = false
                    nailCameraViewModel.isShowingLoadingView = false
                    nailCameraViewModel.disableCaptureButton = false
                    SharedCoreMLModel.shared.disableModelProcessing = false
                }
            }
        }
    }

}

struct optionButton: View {
    var text: String
    
    var body: some View {
        Text(text)
            .frame(width: 125, height: 50)
            .background(Color(.myMeAmore))
            .foregroundStyle(.white)
            .cornerRadius(30)
    }
}
