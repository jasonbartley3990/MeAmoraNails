//
//  Profile Screen.swift
//  MeAmoraNails
//
//  Created by Jason bartley on 11/2/24.
//

import Foundation
import SwiftUI

struct ProfileScreen: View {
    @ObservedObject var viewModel: NailCameraViewModel
    
    @EnvironmentObject var environment: EnvironmentViewModel
    
    @StateObject var profileViewModel: ProfileViewModel = ProfileViewModel()
    
    var body: some View {
        GeometryReader { geo in
            NavigationView {
                ZStack {
                    Color.white.ignoresSafeArea(.all)
                    
                    VStack {
                        Spacer().frame(width: 100, height: 40)
                        
                        HStack {
                            Image("MeAmoraLogo")
                                //.padding(.leading, 20)
                        }.padding(.bottom, 15)
                        
                        HStack {
                            Text("\(environment.userObject?.firstname?.capitalized ?? "Welcome") \(environment.userObject?.lastname?.capitalized ?? "")")
                                .font(.system(size: 24, weight: .bold))
                                .multilineTextAlignment(.leading)
                                .padding(.leading, 20)
                            Spacer()
                        }
                        
                        HStack {
                            if let email = environment.userObject?.email {
                                Text(email)
                                    .multilineTextAlignment(.leading)
                                    .padding(.leading, 20)
                            }
                            
                            Spacer()
                        }
                        
                        HStack {
                            Color.myLightGray
                        }
                        .frame(width: geo.size.width * 0.9, height: 1.5)
                        .padding(.top, 10)
                        .padding(.bottom, 8)
                        
                        RedProfileButton(title: "Measure Nails", image: "MeasureButtonPurple")
                            .frame(width: geo.size.width - 40)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                self.viewModel.showProfile = false
                            }
                            .padding(.bottom, 20)
                        
                        ProfileButton(title: "My Measurements", image: "MyMeasurementButton")
                            .frame(width: geo.size.width - 40)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                viewModel.showPreviousMeasurements = true
                            }
                            .padding(.bottom, 20)
                        
                        ProfileButton(title: "Account Information", image: "ProfileButtonBlack")
                            .frame(width: geo.size.width - 40)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                viewModel.showAccountInformationScreen = true
                            }.padding(.bottom, 20)
                        
                        ProfileButton(title: "Sign Out", image: "SignOutButton")
                            .frame(width: geo.size.width - 40)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                profileViewModel.isShowingSignOutView = true
                            }
                        
//                        HStack {
//                            Color.myLightGray
//                        }
//                        .frame(width: geo.size.width * 0.9, height: 1.5)
//                        .padding(.bottom, 10)
                        
//                        OrangeButtonView(text: "Start New Measurement")
//                            .onTapGesture {
//
//                            }
//                            .padding(.top, 15)
                        
                        Spacer()
                        
                        
//                        HStack {
//                            Image("SignOutButton")
//                                .padding(.leading, 20)
//                                .onTapGesture {
//                                    self.profileViewModel.isShowingSignOutView = true
//                                }
//
//                            Text("Sign out")
//                                .font(.system(size: 18, weight: .semibold))
//                                .onTapGesture {
//                                    profileViewModel.isShowingSignOutView = true
//                                }
//
//                            Spacer()
//                        }.padding(.top, 20)
                        
                       
                    }
                    
                    if profileViewModel.isShowingSignOutView {
                        VStack {
                            SignOutView(viewModel: self.profileViewModel, cameraViewModel: self.viewModel)
                        }
                    }
                }
            }.onAppear(perform: {
                self.environment.getPostMeasurements()
            })
        }
    }
}

struct ProfileButton: View {
    var title: String
    
    var image: String
    
    var body: some View {
        HStack {
            if image == "ProfileButtonBlack" {
                Image(image)
                    .resizable()
                    .frame(width: 18, height: 18)
                    .offset(y: 0)
            } else if image == "SignOutButton"{
                Image(image)
                    .resizable()
                    .frame(width: 18, height: 16)
                    .offset(y: 0)
            } else if image == "MyMeasurementButton" {
                Image(image)
                    .resizable()
                    .frame(width: 16, height: 18)
                    .offset(y: 0)
                
            } else if image == "MeasureButtonPurple" {
                Image(image)
                    .resizable()
                    .frame(width: 18, height: 18)
                    .offset(y: 0)
            }
            Text(title).font(.system(size: 18, weight: .medium))
            Spacer()
            Image(systemName: "chevron.right")
                .padding(.trailing)
                .padding(.top, 20)
        }.buttonStyle(PlainButtonStyle())
    }
}

struct RedProfileButton: View {
    var title: String
    
    var image: String
    
    var body: some View {
        HStack {
            if image == "ProfileButtonBlack" {
                Image(image)
                    .resizable()
                    .frame(width: 18, height: 18)
                    .offset(y: 0)
            } else if image == "SignOutButton"{
                Image(image)
                    .resizable()
                    .frame(width: 18, height: 16)
                    .offset(y: 0)
            } else if image == "MyMeasurementButton" {
                Image(image)
                    .resizable()
                    .frame(width: 16, height: 18)
                    .offset(y: 0)
                
            } else if image == "MeasureButtonPurple" {
                Image(image)
                    .resizable()
                    .frame(width: 18, height: 18)
                    .offset(y: 0)
            }
            Text(title).font(.system(size: 18, weight: .medium))
                .foregroundStyle(.myMeAmore)
            Spacer()
            Image(systemName: "chevron.right")
                .padding(.trailing)
                .padding(.top, 20)
                .foregroundStyle(.myMeAmore)
        }.buttonStyle(PlainButtonStyle())
    }
}

struct SignOutView: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    @ObservedObject var cameraViewModel: NailCameraViewModel
    
    @EnvironmentObject var environment: EnvironmentViewModel
    
    var body: some View {
        ZStack {
            Color.myDarkGray.opacity(0.9).ignoresSafeArea()
            
            Color.white.frame(width: 320, height: 235).cornerRadius(30)
            
            VStack {
                Text("Are you sure?").font(.title2).padding().offset(y: -10)
                
                OrangeButtonView(text: "Sign Out").onTapGesture {
                    signOutUser()
                    self.viewModel.isShowingSignOutView = false
                }
                .padding(.bottom)
                
                Text("Back").foregroundStyle(.myDarkGray).font(.system(size: 18)).onTapGesture {
                    viewModel.isShowingSignOutView = false
                    self.environment.isShowingTabView = true
                }
            }
        }
    }
    
    func signOutUser() {
        self.environment.signOutUser()
        self.environment.successfulMeasurements = []
        self.environment.savedMeasurements = []
        self.environment.savedManualMeasurements = nil
        self.environment.userObject = nil
        self.environment.isLogin = true
        self.cameraViewModel.showProfile = false
    }
}
