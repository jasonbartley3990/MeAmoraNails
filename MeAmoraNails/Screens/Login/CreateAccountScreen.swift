//
//  CreateAccountScreen.swift
//  MeAmoraNails
//
//  Created by Jason bartley on 11/2/24.
//

import Foundation
import SwiftUI

struct CreateAccountScreen: View {
    
    @EnvironmentObject var environment: EnvironmentViewModel
    
    @ObservedObject var viewModel: CreateAccountViewModel = CreateAccountViewModel()
    
    @Environment(\.dismiss) var dismiss
    
    @State private var isLoading: Bool = false {
        didSet {
            print("is loading set to false")
        }
    }
    
    @State private var isKeyboardShowing: Bool = false
    
    @State private var showSafariView: Bool = false
    
    @State private var showSafariViewTerms: Bool = false
    
    @State var privatePolicyUrl: String = "https://meamora.co.uk/pages/privacy-policy"
    
    @State var termsUrl: String = "https://meamora.co.uk/pages/terms-and-conditions"
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea(.all)
            
            ScrollView {
                VStack {
                  
                    Spacer().frame(width: 50, height: 70)
                    
                    Image("MeAmoraLogo")
                    
                    Spacer()
                    
                    HStack {
                        Text("Sign Up").font(.title).bold()
                        Spacer()
                    }
                    .padding(.top)
                    .padding(.trailing, 50)
                    .padding(.leading, 50)
                    
                    Spacer().frame(width: 400, height: 20)
                    
                    HStack {
                        VStack {
                            FieldTitleView(text: "First Name")
                            
                            
                            TextField("", text: $viewModel.firstName)
                                .padding()
                                .frame(maxHeight: 40)
                                .overlay(RoundedRectangle(cornerRadius: 15).stroke(viewModel.firstName.isEmpty ? .myLightGray : .black, lineWidth: 2.2))
                        }
                        
                        
                        VStack {
                            FieldTitleView(text: "Last Name")
                                .padding(.leading, 15)
                            
                            
                            TextField("", text: $viewModel.lastName)
                                .padding()
                                .frame(maxHeight: 40)
                                .overlay(RoundedRectangle(cornerRadius: 15).stroke(viewModel.lastName.isEmpty ? .myLightGray : .black, lineWidth: 2.2))
                                .padding(.leading, 15)
                        }
                    }.padding(.trailing, 50)
                        .padding(.leading, 50)
                    
                    
                    FieldTitleView(text: "Email")
                        .padding(.leading, 50)
                        .padding(.trailing, 50)
                    
                    
                    TextField("Type your email", text: $viewModel.email)
                        .padding()
                        .frame(maxHeight: 40)
                    //.frame(width: 300, height: 40)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(viewModel.email.isEmpty ? .myLightGray : .black, lineWidth: 2.2))
                        .padding(.trailing, 50)
                        .padding(.leading, 50)
                        .padding(.bottom, 5)
                    
                    FieldTitleView(text: "Password")
                        .padding(.leading, 50)
                        .padding(.trailing, 50)
                    
                    VStack {
                        HStack {
                            if viewModel.passwordHidden {
                                SecureField("Type your password", text: $viewModel.password)
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
                        }.overlay(RoundedRectangle(cornerRadius: 15).stroke(viewModel.password.isEmpty ? .myLightGray : .black, lineWidth: 2.2))
                            .padding(.leading, 50)
                            .padding(.trailing, 50)
                    }
                    
                    HStack {
                        Text("8+ Characters      ").foregroundStyle(viewModel.isValidPasswordCount ? .myMeAmore : .gray)
                        Text("1 capital letter").foregroundStyle(viewModel.passwordContainsUppercase ? .myMeAmore : .gray)
                    }.font(.system(size: 15))
                        .padding(.bottom, 5)
                    
                    
                    FieldTitleView(text: "Confirm Password")
                        .padding(.leading, 50)
                        .padding(.trailing, 50)
                    
                    VStack {
                        HStack {
                            if viewModel.confirmPasswordHidden {
                                SecureField("Re-type your password", text: $viewModel.confirmPassword)
                                    .padding()
                                    .frame(maxHeight: 40)
                                    .autocorrectionDisabled()
                                    .textInputAutocapitalization(.never)
                            } else {
                                TextField("Password", text: $viewModel.confirmPassword)
                                    .padding()
                                    .frame(maxHeight: 40)
                                    .autocorrectionDisabled()
                                    .textInputAutocapitalization(.never)
                            }
                            
                            Button(action: {
                                viewModel.confirmPasswordHidden.toggle()
                            }, label: {
                                Image(systemName: viewModel.confirmPasswordHidden ? "eye.fill" : "eye.slash.fill")
                                    .foregroundColor(self.viewModel.confirmPasswordHidden ? Color.black : Color.myMeAmore)
                                    .padding(.trailing)
                            })
                            .buttonStyle(PlainButtonStyle())
                        }.overlay(RoundedRectangle(cornerRadius: 15).stroke(viewModel.confirmPassword.isEmpty ? .myLightGray : .black, lineWidth: 2.2))
                            .padding(.leading, 50)
                            .padding(.trailing, 50)
                    }
                    
                    Spacer().frame(width: 400, height: 25)
                    
                    ZStack {
                        Image("SignUpTerms")
                            .frame(width: 350)
                            .onTapGesture {
                                
                            }
                        
                        HStack {
                            Spacer()
                            
                            Color.clear
                                .frame(width: 120, height: 35)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                   
                                    self.showSafariView = true
                                }
                                .sheet(isPresented: $showSafariView, content: {
                                    if let url = URL(string: self.privatePolicyUrl) {
                                        SFSafari(url: url)
                                    }
                                })
                            
                            Spacer().frame(width: 60)
                            
                            Color.clear
                                .frame(width: 120, height: 35)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    
                                    self.showSafariView = true
                                }
                                .sheet(isPresented: $showSafariViewTerms, content: {
                                    if let url = URL(string: self.termsUrl) {
                                        SFSafari(url: url)
                                    }
                                })
                            Spacer()
                            
                        }.frame(width: 350, height: 35)
                        
                    }.frame(width: 320, height: 35)
                        .padding(.bottom)
                    
                    if viewModel.isNextButtonActive {
                        Button(action: {
                            isLoading = true
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            createAccount()
                        }, label: {
                            OrangeButtonView(text: "Sign Up")
                                .padding(.bottom)
                        }).buttonStyle(PlainButtonStyle())
                    } else {
                        DisabledOrangeButtonView(text: "Sign Up")
                            .padding(.bottom)
                    }
                    
                    HStack {
                        Text("Already have an account?")
                        Text("Sign In")
                            .foregroundStyle(.myMeAmore)
                    }.onTapGesture {
                        environment.isLogin = true
                    }
                    
                    Spacer()
                }
            }.alert(item: $viewModel.alertItem) {
                item in
                Alert(title: Text(item.title), message: Text(item.message), dismissButton: item.dismissbutton)
            }
            
            if isLoading {
                loadingView().opacity(0.9)
            }
        }.onTapGesture {
            hideKeyboard()
        }
        .onDisappear {
            self.viewModel.showCharacterScreen = false
        }
        .navigationBarBackButtonHidden(true)
        
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func createAccount() {
        viewModel.createAccount(completion: {
            success, user in
            if success {
                self.isLoading = false
                let userObject = UserObject(id: user?.id ?? 0, active: user?.active ?? true, email: user?.email ?? "", firstname: user?.firstname ?? "", lastname: user?.lastname ?? "", password: user?.password ?? "", token: user?.token ?? "", valid_measurements: false, avatar_id: viewModel.selectedCharacterId, avatar_name: viewModel.selectedCharacterName, avatar_path: "")
                
                self.environment.userObject = userObject
                self.environment.isSignedIn = true
                self.viewModel.confirmPassword = ""
                self.viewModel.firstName = ""
                self.viewModel.lastName = ""
                self.viewModel.email = ""
                self.viewModel.password = ""
                dismiss()
            } else {
                isLoading = false
            }
        })
    }
}

struct FieldTitleView: View {
    
    var text: String
    
    var body: some View {
        HStack {
            Text(text).font(.headline)
            Spacer()
        }
    }
}
