//
//  LoginScreen.swift
//  MeAmoraNails
//
//  Created by Jason bartley on 11/2/24.
//

import Foundation
import SwiftUI

struct LoginScreen: View, KeyboardReadable {
    @EnvironmentObject var environment: EnvironmentViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel = LoginViewModel()
    
    @State private var isLoading: Bool = false {
        didSet {
            print("is loading is changed for sure")
        }
    }
    
    @State private var isKeyboardShowing: Bool = false
    
    @State private var showSafariView: Bool = false
    
    @State var showSafariViewTerms: Bool = false
    
    @State var currentURL: String = "https://meamora.co.uk/pages/privacy-policy"
    
    @State var privatePolicyUrl: String = "https://meamora.co.uk/pages/privacy-policy"
    
    @State var termsUrl: String = "https://meamora.co.uk/pages/terms-and-conditions"
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                ZStack {
                    Color.white.ignoresSafeArea(.all)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        ScrollViewReader { proxy in
                            VStack {
                                
                                Spacer().frame(width: 50, height: 70)
                                
                                HStack {
                                    Image("MeAmoraLogo")
                                }
                                
                                Spacer()
                                
                                HStack {
                                    Text("Sign In")
                                        .font(.title).bold()
                                    
                                    Spacer()
                                }
                                .padding(.top)
                                .padding(.trailing, 50)
                                .padding(.leading, 50)
                                .padding(.bottom, 20)
                                
                                
                                Spacer().frame(width: 350, height: 5).id(3)
                                
                                HStack {
                                    Text("Email")
                                    Spacer()
                                }
                                .padding(.trailing, 50)
                                .padding(.leading, 50)
                                
                                
                                TextField("Email", text: $viewModel.email).padding()
                                    .frame(maxHeight: 40)
                                    .overlay(RoundedRectangle(cornerRadius: 23).stroke(viewModel.email.isEmpty ? .myLightGray : .black, lineWidth: 2.5))
                                    .keyboardType(.emailAddress)
                                    .textInputAutocapitalization(.never)
//                                    .onReceive(keyboardPublisher) {
//                                        newIsKeyboardVisible in
//                                        isKeyboardShowing = newIsKeyboardVisible
//                                        proxy.scrollTo(3, anchor: .top)
//                                    }
                                    //.id(1)
                                    .padding(.trailing, 50)
                                    .padding(.leading, 50)
                                
                                
                                
                                HStack {
                                    Text("Password")
                                    Spacer()
                                }
                                .padding(.trailing, 50)
                                .padding(.leading, 50)
                                
                                VStack {
                                    HStack {
                                        if viewModel.passwordHidden {
                                            SecureField("Password", text: $viewModel.password)
                                                .padding()
                                                .frame(maxHeight: 40)
                                                .autocorrectionDisabled()
                                                .textInputAutocapitalization(.never)
                                        } else {
                                            TextField("Password", text: $viewModel.password)
                                                .padding()
                                                .frame(maxHeight: 40)
                                                .autocorrectionDisabled()
                                                .textInputAutocapitalization(.never)
                                            
                                        }
                                        
                                        Button(action: {
                                            viewModel.passwordHidden.toggle()
                                        }, label: {
                                            Image(systemName: viewModel.passwordHidden ? "eye.fill" : "eye.slash.fill")
                                                .foregroundColor(self.viewModel.passwordHidden ? Color.black : Color.myMeAmore)
                                                .padding(.trailing)
                                        })
                                        .buttonStyle(PlainButtonStyle())
                                    }.overlay(RoundedRectangle(cornerRadius: 23).stroke(viewModel.password.isEmpty ? .myLightGray : .black, lineWidth: 2.2))
                                        .padding(.leading, 50)
                                        .padding(.trailing, 50)
                                }
                                
                                
                                Spacer().frame(width: 350, height: 20)
                                
                                ZStack {
                                    Image("SignInTerms")
                                        .frame(width: 350)
                                        .onTapGesture {
                                            
                                        }
                                    
                                    HStack {
                                        Spacer()
                                        
                                        Color.clear
                                            .frame(width: 120, height: 35)
                                            .contentShape(Rectangle())
                                            .onTapGesture {
                                                self.currentURL = "https://meamora.co.uk/pages/privacy-policy"
                                                self.showSafariView = true
                                            }
                                            .sheet(isPresented: $showSafariView, content: {
                                                //self.currentURL =  "https://meamora.co.uk/pages/privacy-policy"
                                                if let url = URL(string: self.privatePolicyUrl) {
                                                    SFSafari(url: url)
                                                }
                                            })
                                            .ignoresSafeArea(.all)
                                       
                                        Spacer().frame(width: 60)
                                        
                                        Color.clear
                                            .frame(width: 120, height: 35)
                                            .contentShape(Rectangle())
                                            .onTapGesture {
                                                self.currentURL = "https://meamora.co.uk/pages/terms-and-conditions"
                                                self.showSafariViewTerms = true
                                            }
                                            .sheet(isPresented: $showSafariViewTerms, content: {
                                                if let url = URL(string: self.termsUrl) {
                                                    SFSafari(url: url)
                                                }
                                            })
                                            .ignoresSafeArea(.all)
                                        
                                        Spacer()
                                        
                                    }.frame(width: 350, height: 35)
                                    
                                }.frame(width: 320, height: 35)
                                
                                //AlternateLoginView()
                                
                                Spacer().frame(width: 350, height: 40)
                                
                                if self.viewModel.isNextButtonActive {
                                    
                                    Button(action: {
                                        isLoading = true
                                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                        environment.signOutUser()
                                        login()
                                        
                                    }, label: {
                                        OrangeButtonView(text: "Sign In")
                                    }).buttonStyle(PlainButtonStyle())
                                        .padding(.bottom)
                                    
                                    
                                } else {
                                    DisabledOrangeButtonView(text: "Sign In")
                                        .padding(.bottom)
                                }
                                
                                HStack {
                                    Text("Don't have an account?")
                                    
                                    Text("Sign Up")
                                        .foregroundStyle(.myMeAmore)
                                }.onTapGesture {
                                    environment.isLogin = false
                                }
                                
                                if isLoading {
                                    loadingView().opacity(0.9)
                                }
                                
                            }
                            
                            Spacer().frame(width: 350, height: 350)
                        }
                    }.alert(item: $viewModel.alertItem) {
                        item in
                        Alert(title: Text(item.title), message: Text(item.message), dismissButton: item.dismissbutton)
                    }
                }
                .onTapGesture {
                    hideKeyboard()
                }
            }
        }
    }
    
    func login() {
        let queue = DispatchQueue(label: "loginQueue", attributes: .concurrent)
        
        queue.async {
            viewModel.login { success, user in
                if !success {
                    isLoading = false
                    return
                } else {
                    environment.userObject = user
                    if user?.valid_measurements ?? false {
                        isLoading = false
                        self.environment.isSignedIn = true
                        self.viewModel.email = ""
                        self.viewModel.password = ""
                        dismiss()
                    } else {
                        isLoading = false
                        self.environment.isSignedIn = true
                        self.viewModel.email = ""
                        self.viewModel.password = ""
                        dismiss()
                    }
                }
            }
        }
        
        func checkIfValidSizes(measurement: SaveNailImagesResponse) -> Bool {
            if measurement.leftThumbSize == nil {
                return false
            }
            
            if measurement.leftIndexSize == nil {
                return false
            }
            
            if measurement.leftMiddleSize == nil {
                return false
            }
            
            if measurement.leftRingSize == nil {
                return false
            }
            
            if measurement.leftPinkySize == nil {
                return false
            }
            
            if measurement.rightThumbSize == nil {
                return false
            }
            
            if measurement.rightIndexSize == nil {
                return false
            }
            
            if measurement.rightMiddleSize == nil {
                return false
            }
            
            if measurement.rightRingSize == nil {
                return false
            }
            
            if measurement.rightPinkySize == nil {
                return false
            }
            
            return true
        }
    }
    
    func goToPrivatePolicy() {
        self.showSafariView = true
    }
    
    func goToTerms() {
        self.showSafariView = true
    }
}
