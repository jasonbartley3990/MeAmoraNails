//
//  ErrorPopUp.swift
//  MeAmoraNails
//
//  Created by Jason bartley on 11/2/24.
//

import Foundation
import SwiftUI

struct ErrorPopUp: View {
    
    @ObservedObject var nailCameraViewModel: NailCameraViewModel
    
    var body: some View {
        ZStack {
            
            Color.white.frame(width: 280, height: 280).cornerRadius(30)
            
            VStack {
                Text("Card not detected!").font(.system(size: 25, weight: .bold)).padding(.bottom)
                
                Text("Either card was not in frame\n or not properly positioned").padding(.bottom)
                
                
                OrangeButtonView(text: "ok").onTapGesture {
                    nailCameraViewModel.showErrorPopUp =  false
                }.padding(.bottom)
            }
        }
    }
}
