//
//  ProfileViewModel.swift
//  MeAmoraNails
//
//  Created by Jason bartley on 11/1/24.
//

import Foundation
import SwiftUI

final class ProfileViewModel: ObservableObject {
    @Published var recentMeasuremnets: [Measurements] = []
    
    @Published var isShowingSignOutView: Bool = false
}
