//
//  AccountInformationScreen.swift
//  MeAmoraNails
//
//  Created by Jason bartley on 11/2/24.
//

import Foundation
import SwiftUI

struct AccountInformationScreen: View, KeyboardReadable {
    @EnvironmentObject var environment: EnvironmentViewModel
    
    @ObservedObject var nailCameraViewModel: NailCameraViewModel
    
    @StateObject var viewModel: AccountInfoViewModel = AccountInfoViewModel()
    
    @State private var isKeyboardShowing: Bool = false
    
    @State private var isLoading: Bool = false
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea(.all)
            
            ScrollView {
                VStack {
                    HStack {
                        Spacer().frame(width: 15, height: 15)
                        Image("chevron.left").resizable()
                            .frame(width: 10, height: 14).onTapGesture {
                            self.didTapBack()
                            }.offset(x: -3, y: 1)
                        
                        Spacer()
                        
                        Text("Account Information")
                            .font(.system(size: 24, weight: .bold))
                            .padding()
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                        
                        Image("chevron.right").foregroundStyle(.black).frame(width: 10, height: 14)
                            .hidden()
                        
                        Spacer().frame(width: 15, height: 15)
                    }.padding(.leading).padding(.trailing)
                    
                    Spacer().frame(width: 400, height: 20)
                    
                    FieldTitleView(text: "First Name")
                        .frame(maxHeight: 40)
                        .padding(.top)
                        .padding(.trailing, 50)
                        .padding(.leading, 50)
                    
                    TextField("First Name", text: $viewModel.firstName)
                        .padding()
                        .frame(maxHeight: 40)
                        //.frame(width: 300, height: 40)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke( viewModel.firstName.isEmpty ? .myLightGray : .black, lineWidth: 2.2)).padding(.bottom)
                        .padding(.trailing, 50)
                        .padding(.leading, 50)
                        .onReceive(keyboardPublisher) {
                            newIsKeyboardVisible in
                            isKeyboardShowing = newIsKeyboardVisible
                        }
                    
                    FieldTitleView(text: "Last Name")
                        .frame(maxHeight: 40)
                        .padding(.trailing, 50)
                        .padding(.leading, 50)
                    
                    TextField("Last Name", text: $viewModel.lastName)
                        .padding()
                        .frame(maxHeight: 40)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(viewModel.lastName.isEmpty ? .myLightGray : .black, lineWidth: 2.2)).padding(.bottom)
                        .padding(.trailing, 50)
                        .padding(.leading, 50)
                        .onReceive(keyboardPublisher) {
                            newIsKeyboardVisible in
                            isKeyboardShowing = newIsKeyboardVisible
                        }
                    
                    
                    FieldTitleView(text: "Email")
                        .frame(maxHeight: 40)
                        .padding(.leading, 50)
                        .padding(.trailing, 50)
                    
                    TextField("Email", text: $viewModel.email)
                        .padding()
                        .frame(maxHeight: 40)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(viewModel.email.isEmpty ? .myLightGray : .black, lineWidth: 2.2)).padding(.bottom)
                        .padding(.leading, 50)
                        .padding(.trailing, 50)
                        .onReceive(keyboardPublisher) {
                            newIsKeyboardVisible in
                            isKeyboardShowing = newIsKeyboardVisible
                        }
                    
                    Spacer().frame(width: 400, height: 25)
                    
                    if viewModel.isNextButtonActive {
                        Button(action: {
                            isLoading = true
                            guard let id = environment.userObject?.id else {
                                //self.viewModel.alertItem = AccountInfoAlertContext.unableToSave
                                return
                            }
                            viewModel.saveData(id: id, completion: {
                                success, object in
                                if success {
                                    self.isLoading = false
                                    let userObject = UserObject(id: object?.id ?? 0, active: object?.active ?? true, email: object?.email ?? "", firstname: object?.firstname ?? "", lastname: object?.lastname ?? "", password: object?.password ?? "", token: object?.token ?? "", valid_measurements: false, avatar_id: 0, avatar_name: "", avatar_path: "")
                                    self.environment.userObject = userObject
                                } else {
                                    self.isLoading = false
                                }
                            })
                        }, label: {
                            OrangeButtonView(text: "Save")
                        }).buttonStyle(PlainButtonStyle())
                    } else {
                        DisabledOrangeButtonView(text: "Save")
                    }
                    
                }
            }
//            .alert(item: $viewModel.alertItem) {
//                item in
//                Alert(title: Text(item.title), message: Text(item.message), dismissButton: item.dismissbutton)
//            }
            
            if !self.isKeyboardShowing {
                VStack {
                    Spacer()
                    
                    OutlinedOrangeButton(text: "Delete Account")
                        .onTapGesture {
                            self.viewModel.showDeleteAccountPopUp = true
                        }
                        .padding(.bottom, 20)
                        .scaleEffect(x: 0.8, y: 0.8)
                    
                    
                }
            }
            
            if isLoading {
                loadingView().opacity(0.9)
            }
            
            if viewModel.showAccountInfoSaved {
                InfoSavedPopUp(viewModel: self.viewModel)
            }
            
            if viewModel.showSomethingWrongPopUp {
                SomethingWrongPopUp(viewModel: self.viewModel)
            }
            
            if self.viewModel.showDeleteAccountPopUp {
                Color(.myDarkGray).ignoresSafeArea().opacity(0.7).blur(radius: 30.0)
            }
            
            if self.viewModel.showDeleteAccountPopUp {
                ZStack {
                    Color.white.frame(width: 350, height: 350).cornerRadius(30)
                    
                    VStack {
                        Text("Are you sure you want to delete\nyour account?").font(.system(size: 19, weight: .bold))
                            .padding(.bottom, 3)
                            .multilineTextAlignment(.center)
                        
                        
                        OrangeButtonView(text: "        Yes        ").onTapGesture {
                            
                            APIServices.shared.deleteUser(completion: {
                                success, message in
                                if success {
                                    print("success in account deletion")
                                    self.environment.isSignedIn = false
                                    self.environment.userObject = nil
                                    self.environment.savedMeasurements = []
                                    self.environment.isShowingTabView = true
                                    self.environment.successfulMeasurements = []
                                    self.environment.savedMeasurements = []
                                    self.environment.savedManualMeasurements = nil
                                    self.environment.userObject = nil
                                    self.didTapBack()
                                } else {
                                    print("no success in account deletion")
                                }
                            })
                        }.padding(.bottom)
                        
                        OutlinedOrangeButton(text: "         No         ").onTapGesture {
                            self.viewModel.showDeleteAccountPopUp = false
                        }
                    }
                }
                
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
        .onAppear(perform: {
            self.environment.isShowingTabView = false
            guard let user = self.environment.userObject else {
                return
            }
            self.viewModel.firstName = user.firstname ?? ""
            self.viewModel.lastName = user.lastname ?? ""
            self.viewModel.email = user.email ?? ""
        })
    }
    
    func didTapBack() {
        self.nailCameraViewModel.showAccountInformationScreen = false
    }
}

struct AccountInfoItem: View {
    var title: String
    
    var image: String
    
    var body: some View {
        HStack {
            Image(image).padding()
            Text(title)
            Spacer()
            Image(systemName: "chevron.right").padding()
        }
    }
}

struct signOutButton: View {
    var body: some View {
        HStack {
            Image(systemName:  "rectangle.portrait.and.arrow.right")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundStyle(.myMeAmore)
                .padding()
            Text("Sign Out")
            Spacer()
            Image(systemName: "chevron.right").padding()
        }
    }
}

struct InfoSavedPopUp: View {
    @ObservedObject var viewModel: AccountInfoViewModel
    
    var body: some View {
        ZStack {
            Color.myDarkGray.opacity(0.9).ignoresSafeArea()
            
            Color.white.frame(width: 320, height: 235).cornerRadius(30)
            
            VStack {
                Text("All info saved!").font(.title2).padding().offset(y: -10)
                
                OrangeButtonView(text: "ok").onTapGesture {
                    self.viewModel.showAccountInfoSaved = false
                }
                .padding(.bottom)
            }
        }
    }
}

struct SomethingWrongPopUp: View {
    @ObservedObject var viewModel: AccountInfoViewModel
    
    var body: some View {
        ZStack {
            Color.myDarkGray.opacity(0.9).ignoresSafeArea()
            
            Color.white.frame(width: 320, height: 235).cornerRadius(30)
            
            VStack {
                Text("We are unable to save account info.").font(.title2).padding().offset(y: -10)
                
                OrangeButtonView(text: "ok").onTapGesture {
                    self.viewModel.showAccountInfoSaved = false
                }
                .padding(.bottom)
            }
        }
    }
}

struct AccountInformationButton: View {
    var body: some View {
        HStack {
            Image(systemName:  "person")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundStyle(.myMeAmore)
                .padding()
            Text("Account Information")
            Spacer()
            Image(systemName: "chevron.right").padding()
        }
    }
}

struct HowItWorksButton: View {
    var body: some View {
        HStack {
            Image(systemName:  "info.circle")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundStyle(.myMeAmore)
                .padding()
            Text("How It Works")
            Spacer()
            Image(systemName: "chevron.right").padding()
        }
    }
}

struct AccountInfoWrongView : View {
    var body: some View {
        VStack {
            Text("Account").font(.system(size: 24, weight: .bold)).padding()
            
            AccountInformationButton()
            
            HowItWorksButton()
            
            signOutButton()
            
            Spacer()
        }
    }
}



