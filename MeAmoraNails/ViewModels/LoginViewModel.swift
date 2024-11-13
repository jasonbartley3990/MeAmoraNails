//
//  LoginViewModel.swift
//  MeAmoraNails
//
//  Created by Jason bartley on 11/1/24.
//

import Foundation
import SwiftUI

final class LoginViewModel: ObservableObject {
    @Published var email: String = "" {
        didSet {
            self.isActive()
        }
    }
    
    @Published var password: String = "" {
        didSet {
            self.isActive()
        }
    }
    
    @Published var alertItem: LoginAlertItem?
    
    @Published var passwordHidden: Bool = true
    
    @Published var isNextButtonActive: Bool = false
    
    var isValidForm: Bool {
        guard !email.isEmpty && !password.isEmpty else {
            return false
        }
        return true
    }
    
    func isActive() {
        if isValidForm {
            self.isNextButtonActive = true
        } else {
            self.isNextButtonActive = false
        }
    }
    
    var isValidEmail: Bool  {
        let regularExpression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regularExpression)
        return predicate.evaluate(with: email)
    }
    
    func checkIfValid() -> Bool {
        guard isValidForm else {
            self.alertItem = LoginAlertContext.invalidFields
            return false
        }
        
        guard isValidEmail else {
            self.alertItem = LoginAlertContext.invalidEmail
            return false
        }
        
        return true
    }
    
    func login(completion: @escaping (Bool, UserObject?) -> Void) {
        guard isValidForm else {
            self.alertItem = LoginAlertContext.invalidFields
            completion(false, nil)
            return
        }
        
        guard isValidEmail else {
            self.alertItem = LoginAlertContext.invalidEmail
            completion(false, nil)
            return
        }
        
        let newData = SignInData(email: email, password: password)
        
        APIServices.shared.loginUser(data: newData, email: email, password: password) { [weak self] success, errorMsg, user, validCombo in
            if success {
                print("finish login user")
                completion(true, user)
            } else {
                if validCombo {
                    completion(false, nil)
                    self?.alertItem = LoginAlertContext.wrongCredentials
                } else {
                    completion(false, nil)
                    self?.alertItem = LoginAlertContext.somethingWentWrong
                }
            }
        }
    }
}
