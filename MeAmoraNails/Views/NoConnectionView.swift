//
//  NoConnectionView.swift
//  MeAmoraNails
//
//  Created by Jason bartley on 11/1/24.
//

import Foundation
import SwiftUI

struct NoConnectionView: View {
    @EnvironmentObject var networkManager: NetworkManager
    
    var body: some View {
        ZStack {
            Color.myLightGray
                .frame(width: 290, height: 300)
                .cornerRadius(20)
            
            VStack {
                Image("NoConnection")
                    .frame(width: 60, height: 60)
                    .padding()
                Text("Slow or no internet connection.").font(.system(size: 18, weight: .regular))
                    .padding(.top)
                Text("Please check your wifi or network settings or try again later.")
                    .multilineTextAlignment(.center)
                    .frame(width: 220, height: 80)

            }
        }
    }
}
