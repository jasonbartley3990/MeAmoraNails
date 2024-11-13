//
//  SFSafari.swift
//  MeAmoraNails
//
//  Created by Jason bartley on 11/1/24.
//

import Foundation
import SwiftUI
import SafariServices

struct SFSafari: UIViewControllerRepresentable {
    typealias UIViewControllerType = SFSafariViewController
    
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        let vc = SFSafariViewController(url: url)
        return vc
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        
    }
    
}
