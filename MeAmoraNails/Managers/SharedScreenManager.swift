//
//  SharedScreenManager.swift
//  MeAmoraNails
//
//  Created by Jason bartley on 11/1/24.
//

import Foundation

final class SharedScreenManager {

    static let shared = SharedScreenManager()

    public var width: CGFloat? {
        didSet {
            print("screen width: \(width)")
        }
    }
    
    public var height: CGFloat? {
        didSet {
            print("Screen height: \(height)")
            if height ?? 0 > 800 {
                self.NailStackImage1Size = 110
                self.NailStackImage2Size = 105
                self.NAilStackImage3Size = 150
            } else if height ?? 0 < 800 && height ?? 0 > 650 {
                self.NailStackImage1Size = 85
                self.NailStackImage2Size = 80
                self.NAilStackImage3Size = 115
            } else if height ?? 0 < 650 {
                
            }
        }
    }
    
    public var cardWith: CGFloat?
    
    public var cardHeight: CGFloat?
    
    public var cardX: CGFloat?
    
    public var cardY: CGFloat?
    
    public var cameraViewWidth: CGFloat?
    
    public var cameraViewHeight: CGFloat?
    
    public var cameraX: CGFloat?
    
    public var cameraY: CGFloat?
    
    public var NailStackImage1Size: CGFloat = 85
    
    public var NailStackImage2Size: CGFloat = 80
    
    public var NAilStackImage3Size: CGFloat = 115

    private init() {}
}
